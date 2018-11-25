package com.cglee079.changoos.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.cglee079.changoos.model.BlogVo;

@Repository
public class CommonCodeDao {
	private static final String namespace = "com.cglee079.changoos.mapper.CommonCodeMapper";

	@Autowired
	private SqlSessionTemplate sqlSession;

	public String get(String group, String code) {
		Map<String, Object> map = new HashMap<>();
		map.put("group", group);
		map.put("code", code);
		
		return sqlSession.selectOne(namespace +".S01", map);
	}

}