<%@ page pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/included/included-fileupload.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/study/study-upload.css"/>
<script src="${pageContext.request.contextPath}/resources/js/included/included-fileupload.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/study/study-upload.js"></script>

<body>
	<div class="wrapper">
		<c:import url="../included/included_nav.jsp" charEncoding="UTF-8"/>
		<div class="wrap-upload-form">
			<div class="upload-title">스터디 업로드</div>
		
			<form id="uploadForm" action="${pageContext.request.contextPath}/mgnt/study/upload.do" method="post" enctype="multipart/form-data" class="upload-form">
				<c:if test="${not empty study}">
					<input type="hidden" name="seq" value="<c:out value='${study.seq}'/>"/>
					<input type="hidden" name="date" value="<c:out value='${study.date}'/>"/>
					<input type="hidden" name="hits" value="<c:out value='${study.hits}'/>"/>
				</c:if>
				
				<div class="study-upload-item">
					<div class="item-name">카테고리</div>
					<div class="item-input"><input type="text" id="category" name="category"  value="<c:out value='${study.category}'/>" class="study-category" ></div>
				</div>
				
				<div class="study-upload-item">
					<div class="item-name">개발언어</div>
					<div class="item-input"><input type="text" id="codeLang" name="codeLang"  value="<c:out value='${study.codeLang}'/>" class="study-codelang"></div>
				</div>
				
				<div class="study-upload-item">
					<div class="item-name">제목</div>
					<div class="item-input"><input type="text" id="title" name="title"  value="<c:out value='${study.title}'/>" class="study-title"></div>
				</div>
				
				<div class="study-upload-item">
					<div class="item-name">내용</div>
					<div class="item-input">
						<textarea id="study-contents" name="contents" class="ckeditor-autosave study-contents">
							<c:out value="${study.contents}" escapeXml="false"/>
						</textarea>
					</div>
				</div>
				
				<script>
				function openImageUploadPopup(textArea){
					var popup = window.open(getContextPath() + "/mgnt/image/upload", "_blank", 'width=600, height=800');
					$("#textArea", popup.document).val(textArea);
				}
				</script>

				<div class="study-upload-item">
					<div class="item-name">이미지</div>
					<div class="item-input">
						<div class="image-upload " onclick="openImageUploadPopup('study-contents')">사진올리기</div>
						<div class="image-list"></div>
					</div>
					<style>
					.image-upload{
						width: 100%;	
					    height: 30px;
					    border: 1px solid #CCC;
					    background: #FAFAFA;
					    text-align: center;
					    }
					</style>
				</div>
				
				<div class="study-upload-item">
					<div class="item-name">첨부파일</div>
					<div class="item-input">
						<c:import url="../included/included_fileupload.jsp" charEncoding="UTF-8">
							<c:param name="boardType" value="study"/>
						</c:import>
					</div>
				</div>
				
				<div class="study-upload-item">
					<div class="item-name"></div>
					<div class="item-input study-submit">
						<a class="btn" onclick="Progress.start(); history.back();">취소</a>
						<a class="btn" onclick="Progress.start(); $('#uploadForm').submit()">저장</a>
					</div>
				</div>	
				
			</form>
		</div>
		<c:import url="../included/included_footer.jsp" charEncoding="UTF-8" />
	</div>
</body>
</html>