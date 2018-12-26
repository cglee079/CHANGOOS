package com.cglee079.changoos.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cglee079.changoos.dao.CommonStringDao;

@Service
public class CommonStringService{
	@Autowired
	CommonStringDao commonStringDao;
	

	public String get(String groupID, String strID) {
		return commonStringDao.get(groupID, strID);
	}
	
}