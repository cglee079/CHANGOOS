package com.cglee079.changoos.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.cglee079.changoos.service.ImageUploadService;

@Controller
public class ImageUploadController {
	@Autowired
	private ImageUploadService imageUploadService;
	
	@RequestMapping("/mgnt/image/upload")
	public String imageUpload(Model model, String editor) {
		model.addAttribute("editor", editor);
		return "popup/popup_imageupload";
	}
	
	@ResponseBody
	@RequestMapping("/mgnt/image/upload.do")
	public String imageDoUpload(Model model, MultipartFile image) throws IllegalStateException, IOException {
		String pathname= imageUploadService.saveContentImage(image);
		
		JSONObject result = new JSONObject();
		result.put("pathname", pathname);
		
		return result.toString();
	}
	
		
	@ResponseBody
	@RequestMapping(value = "/mgnt/image/paste-upload.do")
	public String imageDoPasteUpload(HttpServletRequest request, String base64) throws IllegalStateException, IOException {
		String pathname = imageUploadService.saveContentImage(base64);
		
		JSONObject result = new JSONObject();
		result.put("filename", pathname);
		result.put("pathname", pathname);
		
		return result.toString();
	}
	
}