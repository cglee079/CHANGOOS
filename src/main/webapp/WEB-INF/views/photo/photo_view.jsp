<%@ page pageEncoding="UTF-8" %>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp" %>
<sec:authorize access="hasRole('ROLE_ADMIN')" var="isAdmin"></sec:authorize>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/photo/photo-view.css" />
<script src="${pageContext.request.contextPath}/resources/js/photo/photo-view.js"></script> 
</head>
<body>
<div class="wrapper">
	<c:import url="../included/included_nav.jsp" charEncoding="UTF-8">
	</c:import>

	<input type="hidden" id="seqs" value="<c:out value='${seqs}'/>"/>
	
	<div class="wrap-photo-list">
		<div class="photo-list">
			<div class="photo-list-item">
				<input type="hidden" id="photo-seq"/>
				<div class="photo-img"></div>
				<div class="photo-sub">
					<div class="photo-menu">
						<div class="btn btn-photo-like" onclick="increaseLike(this)" style="background-image: url(${pageContext.request.contextPath}/resources/image/btn-photo-like.svg);"></div>
						<div class="btn btn-photo-comment" onclick="showWriteComment(this)" style="background-image: url(${pageContext.request.contextPath}/resources/image/btn-photo-comment.svg);"></div>
					</div>
					
					<div class="photo-detail">
						<div class="photo-info">
							<div class="photo-name"></div>
							<div class="photo-like"></div>
							<div style="flex : 1"></div>
							<div class="photo-date-loc"></div>
						</div>
						<div class="photo-info2">
							<div class="photo-tag"></div>
						</div>
						
						<div class="photo-desc editor-contents"></div>
					</div>
					
					<div class="photo-comments">			
					</div>
					
					<div class="photo-write-comment none">
						<div class="write-userinfo">
							<div><input type="text" class="name" placeholder="NAME" style="font-size: 0.6rem"></div>
							<div><input type="password" class="password" placeholder="PWD" style="font-size: 0.6rem"></div>
						</div>
						<div class="write-comment">
							<div><textarea class="contents" style="font-size: 0.6rem"></textarea></div>
						</div>
							<div class="btn btn-write col-center" onclick="doWriteComment(this)">등록</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="snapsht-list">
			<div class="snapsht-list-cut"></div>
			<c:forEach items="${photos}" var="photo" varStatus="status" >
				<div class="btn snapsht-list-item" onclick="showPhoto('${status.index}')"  
					style="background-image: url('${pageContext.request.contextPath}${photo.snapsht}')">
				</div>
			</c:forEach>
			<div class="snapsht-list-cut"></div>
		</div>
	</div>
	
</div>

</body>
</html>