<%@ page pageEncoding="UTF-8" %>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/included/included-project-list.css" /> 
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home-basic.css" />
<script src="${pageContext.request.contextPath}/resources/js/included/included-project-list.js"></script>
<script>
function scrollToItems(){
	var top = $(".wrap-project-list").offset().top;
	$("html, body").animate({ scrollTop: (top - 50) });
}

function relocateItemTitle(){
	var itemTitle = $(".wrap-project-list");
	var offset = itemTitle.offset();
	var top = offset.top;
	
	if(top < deviceHeight){
		var marginTop = parseInt(itemTitle.css("margin-top"));
		itemTitle.css("margin-top", marginTop + (deviceHeight - top));
	}
}	

$(document).ready(function(){
	relocateItemTitle();
})

$(window).resize(function(){
	relocateItemTitle();
})
</script>
</head>
<body>
	
<div class="wrapper">
	<c:import url="included/included_nav.jsp" charEncoding="UTF-8" />
	
	<div class="main">
		<div class="wrap-introduce">
			<div class="me-icon" style="background-image : url(resources/image/home_icon_me.png);">
			</div>
			
			<div class="introduce">
				<div class="introduce-name">
					<div class="ml9">
					  <span class="text-wrapper">
					    <span class="letters">Changoo Lee</span>
					  </span>
					</div>
				</div>
				
				<div class="introduce-desc">
					Hello! Thank you for visiting my site. <br/>
					I specialized Computer Engineering at Hansung University.<br/>
					and interested in <strong>Android, Web development.</strong><br/>
					If you want to see my projects, show below.<br/>
					<br/>
					<a href="javascript:void(0)" onclick="scrollToItems()" class ="btn btn-show-items" >going on</a>
				</div>
			</div>
		</div>
		
		<div class="wrap-project-list">
			<div class="item-head row-center">
				<div class="circle"></div>
				<div class="circle"></div>
				<div class="circle"></div>
			</div>
			<%@ include file="included/included_project_list.jsp" %>
		</div>
	</div>
	
	<c:import url="included/included_footer.jsp" charEncoding="UTF-8" />
</div>
</body>
</html>


