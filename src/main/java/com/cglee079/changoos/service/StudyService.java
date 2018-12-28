package com.cglee079.changoos.service;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cglee079.changoos.dao.StudyDao;
import com.cglee079.changoos.model.BoardFileVo;
import com.cglee079.changoos.model.BoardImageVo;
import com.cglee079.changoos.model.StudyVo;
import com.cglee079.changoos.util.AuthManager;
import com.cglee079.changoos.util.Formatter;
import com.cglee079.changoos.util.MyFileUtils;

@Service
public class StudyService {
	@Autowired
	private BoardImageService boardImageService;
	
	@Autowired
	private BoardFileService boardFileService;
	
	@Autowired
	private StudyDao studyDao;
	
	@Value("#{servletContext.getRealPath('/')}")
	private String realPath;

	@Value("#{location['study.file.dir.url']}")
	private String fileDir;
	
	@Value("#{location['study.image.dir.url']}")
	private String imageDir;
	
	@Value("#{tb['study.file.tb.name']}")
	private String fileTB;
	
	@Value("#{tb['study.image.tb.name']}")
	private String imageTB;
	
	public int count(Map<String, Object> params) {
		return studyDao.count(params);
	}
	
	@Transactional
	public StudyVo get(int seq) {
		StudyVo study = studyDao.get(seq);
		study.setImages(boardImageService.list(imageTB, seq));
		study.setFiles(boardFileService.list(fileTB, seq));
		
		if(study.getContents() != null) {
			study.setContents(study.getContents().replace("&", "&amp;"));
		}
		
		return study;
	}
	
	
	@Transactional
	public StudyVo doView(List<Integer> isVisitStudies, int seq) {
		StudyVo study = studyDao.get(seq);
		study.setImages(boardImageService.list(imageTB, seq));
		study.setFiles(boardFileService.list(fileTB, seq));

		if (!isVisitStudies.contains(seq) && !AuthManager.isAdmin()) {
			isVisitStudies.add(seq);
			study.setHits(study.getHits() + 1);
			studyDao.update(study);
		}
		
		return study;
	}
	

	public StudyVo getBefore(int seq, String category) {
		return studyDao.getBefore(seq, category);
	}

	public StudyVo getAfter(int seq, String category) {
		return studyDao.getAfter(seq, category);
	}
	
	public List<String> getCategories() {
		return studyDao.getCategories();
	}

	public List<StudyVo> list(Map<String, Object> map) {
		return studyDao.list(map);
	}

	@Transactional(rollbackFor = {IllegalStateException.class, IOException.class })
	public int insert(StudyVo study, String imageValues, String fileValues) throws IllegalStateException, IOException {
		study.setDate(Formatter.toDate(new Date()));
		study.setHits(0);
		
		int seq = studyDao.insert(study);
		boardFileService.insertFiles(fileTB, fileDir, seq, fileValues);
		
		String contents = boardImageService.insertImages(imageTB, imageDir, seq, study.getContents(), imageValues);
		study.setContents(contents);
		
		studyDao.update(study);
		
		return seq;
	}


	@Transactional(rollbackFor = {IllegalStateException.class, IOException.class })
	public boolean update(StudyVo study, String imageValues, String fileValues) throws IllegalStateException, IOException {
		int seq = study.getSeq();
		boardFileService.insertFiles(fileTB, fileDir, seq, fileValues);
		
		String contents = boardImageService.insertImages(imageTB, imageDir, seq, study.getContents(), imageValues);
		study.setContents(contents);
		
		boolean result = studyDao.update(study);
		return result;
	}
	
	@Transactional
	public boolean delete(int seq) {
		List<BoardImageVo> images = boardImageService.list(imageTB, seq);
		List<BoardFileVo> files = boardFileService.list(fileTB, seq);
		MyFileUtils fileUtils = MyFileUtils.getInstance();
		
		boolean result = studyDao.delete(seq); //CASECADE
		if(result) {
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
	

	public List<StudyVo> paging(Map<String, Object> params) {
		int page = Integer.parseInt((String) params.get("page"));
		int perPgLine = Integer.parseInt((String) params.get("perPgLine"));
		int startRow = (page - 1) * perPgLine;
		params.put("startRow", startRow);

		List<StudyVo> studies = studyDao.list(params);
		StudyVo study = null;
		String contents = null;
		String newContents = "";
		Document doc = null;
		Elements els = null;
		for (int i = 0; i < studies.size(); i++) {
			study = studies.get(i);

			// 내용중 텍스트만 뽑기
			contents = study.getContents();
			newContents = "";
			doc = Jsoup.parse(contents);
			els = doc.select("*");
			if (els.eachText().size() > 0) {
				newContents = els.eachText().get(0);
			}

			newContents.replace("\n", " ");
			study.setContents(newContents);
		}

		return studies;
	}
}
