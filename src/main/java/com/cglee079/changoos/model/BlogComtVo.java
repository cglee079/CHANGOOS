package com.cglee079.changoos.model;

public class BlogComtVo {
	private int seq;
	private int blogSeq;
	private String name;
	private String password;
	private String contents;
	private String date;
	private Integer parentSeq;

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public int getBlogSeq() {
		return blogSeq;
	}

	public void setBlogSeq(int blogSeq) {
		this.blogSeq = blogSeq;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public Integer getParentSeq() {
		return parentSeq;
	}

	public void setParentSeq(Integer parentSeq) {
		this.parentSeq = parentSeq;
	}

}