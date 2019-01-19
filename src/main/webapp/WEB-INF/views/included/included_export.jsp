<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>

<script>
$(document).ready(function(){
	var data = {
		thumbnail 	: '${param.thumbnail}',
		title 		: '${param.title}',
		comtCnt 	:'${param.comtCnt}'
	}
	
	initExportKakao(data);
})

function drawExportView(){
	$(".wrap-export").addClass("on");
	$("html, body").css("overflow", "hidden");
	$("html, body").on("scroll touchmove mousewheel", function(event) {
		event.preventDefault();
		event.stopPropagation();
		return false;
	});
}

function exitExportView(){
	$(".wrap-export").removeClass("on");
	$("html, body").off("scroll touchmove mousewheel");
	$("html, body").css("overflow", "");
}

</script>

<div class="wrap-export">
	<div class="btn btn-export-exit" onclick="exitExportView()">
		<span></span>
		<span></span>
	</div>

	<div class="wrap-export-img">
		<div class="bg-img"></div>
		<c:if test="${!empty param.thumbnail}">
			<div class="img">
				<img src="${pageContext.request.contextPath}${param.thumbnail}"/>
			</div>
		</c:if>
	</div>

	<div class="exports">
		<div class="btn exp exp-url">
			<img class="exp-icon" src="${pageContext.request.contextPath}/resources/image/btn-export-url.svg">
			<span>URL 복사</span>
		</div>
		<div id="expKakaotalk" class="btn exp exp-kakaotalk">
			<img class="exp-icon" src="${pageContext.request.contextPath}/resources/image/btn-export-kakaotalk.svg">
			<span>카카오톡 공유하기</span>
		</div>

	</div>

</div>

<style>
.wrap-export {
	z-index: 10;
	position: fixed;
	top: 60px;
	left: -100%;
	width : 600px;
	height : 100%;
	display: flex;
	flex-flow: column;
	transition: left .2s cubic-bezier(0.215, 0.61, 0.355, 1);
}

@media ( max-width : 800px) {
	.wrap-export {
		width : 100%;
	}
}
	
.wrap-export.on{
	left : 0;
}

.btn-export-exit {
	z-index: 11;
	position: absolute;
	left: 0;
	top: 0;
	margin : 10px;
	padding: 20px;
}

.btn-export-exit span{
    display: block;
    position: absolute;
    height: 1.5px;
    width: 100%;
    background: #FFF;
    border-radius: 9px;
    left: 0;
}

.btn-export-exit span:nth-child(1){
	-webkit-transform: rotate(45deg);
    -moz-transform: rotate(45deg);
    -o-transform: rotate(45deg);
    transform: rotate(45deg);
}

.btn-export-exit span:nth-child(2){
    -webkit-transform: rotate(-45deg);
    -moz-transform: rotate(-45deg);
    -o-transform: rotate(-45deg);
    transform: rotate(-45deg);
}


.wrap-export-img {
	width: 100%;
	height: 40%;
	
	position: relative;
}

.wrap-export-img .bg-img{
	position : absolute;
	left : 0;
	right : 0;
	top : 0;
	bottom: 0;
	background: #000;
	opacity: 0.7;
}

.wrap-export-img .img{
	position : absolute;
	left : 0;
	right : 0;
	top : 0;
	bottom: 0;
	
	display : flex;
	align-items : center;
	justify-content: center;
}

.wrap-export-img .img img{
	max-height: 70%;
	max-width : 80%;
}

.exports {
	flex: 1;
	background: #FFF;
	padding-top : 20px;
}

.exports .exp {
	display: flex;
	align-items: center;
	padding: 0.5rem 2rem;
	font-weight: bold;
}

.exports .exp .exp-icon {
	width: 35px;
	margin: 1.2rem;
}
</style>

<script>
function initExportKakao(data){
	var url = window.location.href;
	var thumbnailURL = window.location.origin + data.thumbnail;
	
	Kakao.init('3684e89896f38ed809137a3e7062bf95');
	
	// 카카오링크 버튼을 생성
	Kakao.Link.createDefaultButton({
		container: '#expKakaotalk',
		objectType: 'feed',
  		content: {
    		title: data.title,
    		imageUrl: thumbnailURL,
    		link: {
    			mobileWebUrl: url,
    			webUrl: url
    		}
  		},
  		social: {
 	        commentCount: parseInt(data.comtCnt),
 	    },
  		buttons: [
			{
	   			title: '웹으로 보기',
	   			link: {
					mobileWebUrl: url,
					webUrl: url
				}
			}
  		]
	});
}
</script>