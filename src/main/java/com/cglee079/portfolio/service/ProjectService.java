package com.cglee079.portfolio.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cglee079.portfolio.dao.ProjectDao;
import com.cglee079.portfolio.dao.ProjectFileDao;
import com.cglee079.portfolio.model.FileVo;
import com.cglee079.portfolio.model.ProjectVo;

@Service
public class ProjectService {
	@Autowired
	private ProjectDao projectDao;
	
	public List<ProjectVo> list(){
		return projectDao.list();
	}
	
	public int insert(ProjectVo project) {
		project.setContents(project.getContents());
		project.setDesc(project.getDesc());
		
		project.setHits(0);
		return projectDao.insert(project);
	}

	public boolean update(ProjectVo project) {
		return projectDao.update(project);
	}
	
	public boolean delete(int seq) {
		return projectDao.delete(seq);
	}
	
	public ProjectVo get(int seq){
		return projectDao.get(seq);
	}
	
	public List<String> getContentImgPath(int seq, String path){
		List<String> imgPaths = new ArrayList<String>();
		ProjectVo project = projectDao.get(seq);
		String content = project.getContents();
		
		int stIndex = 0;
		int endIndex= 0;
		
		if(content != null){
			while(true){
				stIndex = content.indexOf(path, endIndex);
				endIndex = content.indexOf("\"", stIndex);
				
				if(stIndex == -1){ break;}
				if(endIndex == -1){ break;}
				
				imgPaths.add(content.substring(stIndex, endIndex));
			}
		}
		
		return imgPaths;
	}

	public ProjectVo getBefore(int sort) {
		return projectDao.getBefore(sort);
	}

	public ProjectVo getAfter(int sort) {
		return projectDao.getAfter(sort);
	}

}
