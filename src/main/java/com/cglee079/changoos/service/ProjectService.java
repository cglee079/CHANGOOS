package com.cglee079.changoos.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.imageio.ImageIO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.cglee079.changoos.dao.ProjectDao;
import com.cglee079.changoos.dao.ProjectFileDao;
import com.cglee079.changoos.dao.ProjectImageDao;
import com.cglee079.changoos.model.FileVo;
import com.cglee079.changoos.model.ImageVo;
import com.cglee079.changoos.model.ProjectVo;
import com.cglee079.changoos.util.AuthManager;
import com.cglee079.changoos.util.ImageManager;
import com.cglee079.changoos.util.MyFileUtils;
import com.cglee079.changoos.util.MyFilenameUtils;
import com.cglee079.changoos.util.PathHandler;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class ProjectService {
	@Autowired
	private ProjectDao projectDao;
	
	@Autowired
	private ProjectFileDao projectFileDao;
	
	@Autowired
	private ProjectImageDao projectImageDao;
	
	@Value("#{servletContext.getRealPath('/')}")
	private String realPath;
	
	@Value("#{location['temp.file.dir.url']}")
	private String fileTempDir;
	
	@Value("#{location['temp.image.dir.url']}")
	private String imageTempDir;
	
	@Value("#{location['project.file.dir.url']}")
	private String fileDir;
	
	@Value("#{location['project.image.dir.url']}")
	private String imageDir;
	
	@Value("#{location['project.thumb.dir.url']}")
	private String thumbDir;
	
	@Transactional
	public ProjectVo get(int seq) {
		ProjectVo project = projectDao.get(seq);
		project.setImages(projectImageDao.list(seq));
		project.setFiles(projectFileDao.list(seq));
		
		String contents = project.getContents();
		if (contents != null) {
			project.setContents(contents.replace("&", "&amp;"));
		}
		
		return project;
	}

	@Transactional
	public ProjectVo doView(List<Integer> isVisitProject, int seq) {
		ProjectVo project = projectDao.get(seq);
		project.setImages(projectImageDao.list(seq));
		project.setFiles(projectFileDao.list(seq));
		
		if (!isVisitProject.contains(seq) && !AuthManager.isAdmin()) {
			isVisitProject.add(seq);
			project.setHits(project.getHits() + 1);
			projectDao.update(project);
		}
		return project;
	}
	
	public List<ProjectVo> list(Map<String, Object> map) {
		return projectDao.list(map);
	}

	@Transactional(rollbackFor = {IllegalStateException.class, IOException.class})
	public int insert(ProjectVo project, MultipartFile thumbnailFile, String imageValues, String fileValues) throws IllegalStateException, IOException {
		String thumbnail = this.saveThumbnail(project, thumbnailFile);
		project.setThumbnail(thumbnail);

		String contents = PathHandler.changeImagePath(project.getContents(), imageTempDir, imageDir);
		project.setContents(contents);
		project.setHits(0);
		
		int seq = projectDao.insert(project);
		List<ImageVo> images = new ObjectMapper().readValue(imageValues, new TypeReference<List<ImageVo>>(){});
		this.saveImages(seq, images);

		List<FileVo> files = new ObjectMapper().readValue(fileValues, new TypeReference<List<FileVo>>(){});
		this.saveFiles(project, files);
		
		return seq;
	}

	@Transactional(rollbackFor = {IllegalStateException.class, IOException.class})
	public boolean update(ProjectVo project, MultipartFile thumbnailFile, String imageValues, String fileValues) throws IllegalStateException, IOException {
		String thumbnail = this.saveThumbnail(project, thumbnailFile);
		project.setThumbnail(thumbnail);

		String contents = PathHandler.changeImagePath(project.getContents(), imageTempDir, imageDir);
		project.setContents(contents);
		
		boolean result = projectDao.update(project);
		List<ImageVo> images = new ObjectMapper().readValue(imageValues, new TypeReference<List<ImageVo>>(){});
		this.saveImages(project.getSeq(), images);
		
		List<FileVo> files = new ObjectMapper().readValue(fileValues, new TypeReference<List<FileVo>>(){});
		this.saveFiles(project, files);
		
		return result;
	}

	@Transactional
	public boolean delete(int seq) {
		ProjectVo project = projectDao.get(seq);
		List<FileVo> files = projectFileDao.list(seq);
		List<ImageVo> images = projectImageDao.list(seq);
		MyFileUtils fileUtils = MyFileUtils.getInstance();
		
		boolean result = projectDao.delete(seq);
		if(result) {
			//스냅샷 삭제
			fileUtils.delete(realPath + thumbDir, project.getThumbnail());
			
			//첨부 파일 삭제
			for (int i = 0; i < files.size(); i++) {
				fileUtils.delete(realPath + fileDir, files.get(i).getPathname());
			}
			
			//첨부 이미지 삭제
			for (int i = 0; i < images.size(); i++) {
				fileUtils.delete(realPath + imageDir, images.get(i).getPathname());
			}
		}
		return result;
	}



	public ProjectVo getBefore(int seq) {
		return projectDao.getBefore(seq);
	}

	public ProjectVo getAfter(int seq) {
		return projectDao.getAfter(seq);
	}

	
	public String saveThumbnail(ProjectVo project, MultipartFile thumbnailFile) throws IllegalStateException, IOException {
		String filename = thumbnailFile.getOriginalFilename();
		String imgExt = MyFilenameUtils.getExt(filename);
		String pathname = null;
		
		if (thumbnailFile.getSize() != 0) {
			MyFileUtils fileUtils = MyFileUtils.getInstance();
			
			fileUtils.delete(realPath + thumbDir, project.getThumbnail());

			pathname = "PROJECT.THUMB." + MyFilenameUtils.getRandomImagename(imgExt);
			File file = new File(realPath + thumbDir, pathname);
			thumbnailFile.transferTo(file);
			
			if (!imgExt.equalsIgnoreCase(ImageManager.EXT_GIF)) {
				ImageManager imageManager = ImageManager.getInstance();
				BufferedImage image = imageManager.getLowScaledImage(file, 1080, imgExt);
				ImageIO.write(image, imgExt, file);
			}

		}

		return pathname;
	}

	/***
	 * 내용 중 이미지 첨부 관련
	 ***/
	private void saveImages(int projectSeq, List<ImageVo> images) {
		ImageVo image;
		MyFileUtils fileUtils = MyFileUtils.getInstance();
		
		for (int i = 0; i < images.size(); i++) {
			image = images.get(i);
			image.setBoardSeq(projectSeq);
			switch(image.getStatus()) {
			case "NEW" : //새롭게 추가된 이미지
				if(projectImageDao.insert(image)) {
					//임시폴더에서 본 폴더로 이동
					File existFile  = new File(realPath + imageTempDir, image.getPathname());
					File newFile	= new File(realPath + imageDir, image.getPathname());
					fileUtils.move(existFile, newFile);
				}
				break;
			case "REMOVE" : //기존에 있던 이미지 중, 삭제된 이미지
				if(projectImageDao.delete(image.getSeq())) {
					fileUtils.delete(realPath + imageDir, image.getPathname());
				}
				break;
			}
		}
		
		//업로드 파일로 이동했음에도 불구하고, 남아있는 TEMP 폴더의 이미지 파일을 삭제.
		//즉, 이전에 글 작성 중 작성을 취소한 경우 업로드가 되었던 이미지파일들이 삭제됨.
		fileUtils.emptyDir(realPath + imageTempDir);
	}
	
	/**
	 * 파일 첨부 관련 메소드
	 */
	
	private void saveFiles(ProjectVo project, List<FileVo> files) throws IllegalStateException, IOException {
		int projectSeq = project.getSeq();
		MyFileUtils fileUtils = MyFileUtils.getInstance();
		
		FileVo file;
		for (int i = 0; i < files.size(); i++) {
			file = files.get(i);
			file.setBoardSeq(projectSeq);
			switch(file.getStatus()) {
			case "NEW" : //새롭게 추가된 파일
				if(projectFileDao.insert(file)) {
					//임시폴더에서 본 폴더로 이동
					File existFile  = new File(realPath + fileTempDir, file.getPathname());
					File newFile	= new File(realPath + fileDir, file.getPathname());
					fileUtils.move(existFile, newFile);
				}
				break;
			case "REMOVE" : //기존에 있던 이미지 중, 삭제된 이미지
				if(projectFileDao.delete(file.getSeq())) {
					fileUtils.delete(realPath + fileDir, file.getPathname());
				}
				break;
			}
		}
		
		fileUtils.emptyDir(realPath + fileTempDir);
	}
	
	


}
