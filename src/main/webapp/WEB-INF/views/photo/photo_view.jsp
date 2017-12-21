<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp" %> 
<style>
.photo-view{
	width: 100%;
	height : 450px;
	padding : 20px 0px;
	margin-top: 0.5rem;
	border: 1px solid #eee;
	background: #FFF;
}

.photo-view > .photo-img{
	width : 100%;
	height: 70%;
	background-position	: center;
    background-repeat	: no-repeat;
    background-size		: contain;
}

.photo-view > .photo-detail{
	padding : 0.5rem;
	width: 60%;
	margin: 0px auto;
	margin-top: 1rem;
	height : 25%;
}

.photo-view > .photo-detail > .photo-info{
	display: flex;
	justify-content: space-between;
}

.photo-view > .photo-detail > .photo-info > .photo-name{
	color: #000;
	font-weight: bold;
	font-size: 0.8rem;
}

.photo-view > .photo-detail > .photo-info .photo-date-loc{
	color: #555;
	font-size: 0.5rem;
	margin-right: 0.5rem;
}

.photo-view > .photo-detail > .photo-tag{
	margin-top: 5px;
	color : #33F;
	font-size: 0.5rem;
}

.photo-view > .photo-detail > .photo-desc{
	margin-top: 5px;
	width : 100%;
	height: 80%;
	overflow : hidden;
	color : #555;
	font-size: 0.6rem;
	word-break : break-all;
}


.wrap-photo-list{
	height : 4rem;
	display : flex;
	width : 90%;
	margin: 0px auto;
	margin-top: 30px;
	
	-ms-flex-align: center;
	-webkit-align-items: center;
	-webkit-box-align: center;

	align-items: center;
}

.photo-list{
	flex : 8;
	width: 80%;
	height : 100%;
	position: relative;
	overflow: hidden;
	margin : 0px auto;
}

.btn-left-list{
	flex : 1;
	width: 20px;
	height: 20px;
	
	background-position	: center;
    background-repeat	: no-repeat;
    background-size		: contain;
}

.btn-right-list{
	flex : 1;
	width: 20px;
	height: 20px;
	
	background-position	: center;
    background-repeat	: no-repeat;
    background-size		: contain;
}

.photo-item{
	position : absolute;
	height : 100%;
	background-position	: center;
    background-repeat	: no-repeat;
    background-size		: contain;
}

@media (max-width: 420px){
	.photo-view > .photo-detail {
		width: 80%;
		margin-top: 0.5rem;
	}
	
	.photo-view > .photo-detail > .photo-info > .photo-name{
		font-size: 1rem;
	}
	
	.photo-view > .photo-detail > .photo-tag{
		font-size: 0.7rem;
	}
	
	.photo-view > .photo-detail > .photo-desc{
		font-size: 0.8rem;
	}
	
	.btn-left-list{
		width: 10px;
		height: 10px;
	}
	
	.btn-right-list{
		width: 10px;
		height: 10px;
	}
}

</style>
<script>
	function photoSnapshtResize(){
		var photoItems = $(".photo-item");
		var length = photoItems.length;
		
		photoItems.each(function(){
			var tg = $(this);
			var height 	= parseInt(tg.css("height"));
			var width	= height * (4/3);
			tg.css("width", width);
		});
		
		for(var i = 0; i < length; i++){
			var tg = photoItems.eq(i);
			var width = parseInt(tg.css("width"));
			tg.stop().css("left", (width * i) + (5 * i));
		}
	}
	
	function showPhoto(seq, index){
		var photoItems = $(".photo-list > .photo-item");
		var tg = photoItems.eq(index);
		photoItems.removeClass("on");
		tg.addClass("on");
		
		var tgLeft = parseInt(tg.css("left"));
		photoItems.each(function(){
			var left = parseInt($(this).css("left"));
			var toLeft = left - tgLeft;
			$(this).css({"left" : left}).stop().animate({"left" : toLeft});
		})
		
		$.ajax({
			type	: "POST",
			url 	: "${pageContext.request.contextPath}" + "/photo/view.do",
			dataType: "JSON",
			data 	: {
				"seq" : seq
			},
			success : function(photo) {
			 	$(".photo-view").css("opacity", 0);
				anime({
					  targets	: ".photo-view",
					  duration	: 500,
					  opacity	: 1,
					  easing	: 'easeInOutSine',
				});

				if(photo.device === null){
					photo.device = "";
				}
				$(".photo-img")	.css("background-image", "url('${pageContext.request.contextPath}" + photo.image +"')");
				$(".photo-name").html(photo.name);
				$(".photo-date-loc").html(photo.date + " " + photo.location);
				$(".photo-desc").html(photo.desc);
				$(".photo-tag").html(photo.tag);
				$(".photo-index").html(index);
			}	
		});
	}
	
	$(document).ready(function(){
		var items 		= $(".photo-item");
		items.eq(0).trigger("click");
		 
		$(".btn-right-list").on("click", function(){
			var photoList = $(".photo-list");
			var photoItems = $(".photo-list > .photo-item");
			var wrapWidth = parseInt(photoList.css("width"));
			var length = photoItems.length;
			
			var lastTg 		= photoItems.eq(length - 1);
			var lastLeft 	= parseInt(lastTg.css("left"));
			var lastToLeft 	= lastLeft - wrapWidth;
			var lastToRight = lastLeft + parseInt(lastTg.css("width"));
			
			if(!(lastToRight <= wrapWidth)){
				for(var i = 0; i < length; i++){
					var tg = photoItems.eq(i);
					var width 	= parseInt(tg.css("width"));
					var left 	= parseInt(tg.css("left"));
					var toLeft 	= left - wrapWidth;
					tg.css({"left" : left}).stop().animate({"left" : toLeft});
				}
			}
		});
		
		$(".btn-left-list").on("click", function(){
			var photoList = $(".photo-list");
			var photoItems = $(".photo-list > .photo-item");
			var wrapWidth = parseInt(photoList.css("width"));
			var length = photoItems.length;
			
			var overLeft = false;
			var firstTg 	= photoItems.eq(0);
			var firstLeft 	= parseInt(firstTg.css("left"));
			var firstToLeft = firstLeft + wrapWidth;
			if(firstToLeft > 0){
				overLeft = true;
			}
			
			for(var i = 0; i < length; i++){
				var tg = photoItems.eq(i);
				var width 	= parseInt(tg.css("width"));
				var left 	= parseInt(tg.css("left"));
				var toLeft 	= left + wrapWidth;
				
				if(overLeft){
					tg.stop().animate({"left" : (width * i) + (5 * i) });
				} else {				
					tg.css({"left" : left}).stop().animate({"left" : toLeft});
				}
			}
		});
		
		$(".wrap-photo-list").on("wheel", function(e){
			e.preventDefault();
            var delta = e.originalEvent.deltaY;
            if(delta > 0 ) {$(".btn-right-list").trigger("click"); }
            else  {$(".btn-left-list").trigger("click"); }
		})
		
		$(".photo-view").touchwipe({
		     wipeLeft: function() {
		    	 var tg = $(".photo-view");
		    	 var index 		= parseInt(tg.find(".photo-index").html());
		    	 var toIndex 	= index + 1;
		    	 var items 		= $(".photo-item");
		    	 var itemLength = items.length;
		    	 if(toIndex < itemLength){
					items.eq(toIndex).trigger("click");
		    	 } else{
		    		alert("더 이상 사진이 없습니다.");
		    	 } 
		     },
		     
		     wipeRight: function() {
		    	 var tg = $(".photo-view");
		    	 var index 		= parseInt(tg.find(".photo-index").html());
		    	 var toIndex 	= index - 1;
		    	 var items 		= $(".photo-item");
		    	 if(toIndex >= 0){
		    		 items.eq(toIndex).trigger("click");
		    	 } else{
		    		 alert("더 이상 사진이 없습니다.");
		    	 }
		     },
		     
		     min_move_x: 20,
		     min_move_y: 20,
		     preventDefaultEvents: true
		});
		
		$(".photo-list").touchwipe({
		     wipeLeft: function() {
		    	 $(".btn-right-list").trigger("click");
		     },
		     
		     wipeRight: function() {
		    	 $(".btn-left-list").trigger("click");
		     },
		     
		     min_move_x: 20,
		     min_move_y: 20,
		     preventDefaultEvents: true
		});
		
		photoSnapshtResize();
		$(window).resize(function(){
			photoSnapshtResize();
		});
		
	});
	
</script>
</head>
<body>
<div class="wrapper">
	<c:import url="../included/included_nav.jsp" charEncoding="UTF-8">
	</c:import>
	<div class="wrap-photo-view col-center">
		<div class="photo-view">
			<div class="photo-img"></div>
			<div class="photo-detail">
				<div class="photo-info">
					<div class="photo-name"></div>
					<div class="photo-date-loc">
					</div>
				</div>
				
				<div class="photo-tag"></div>
				<div class="photo-desc editor-contents"></div>
				<div class="photo-index display-none"></div>
			</div>
		</div>
		<div class="wrap-photo-list">
			<div class="btn btn-left-list h-reverse" style="background-image: url(${pageContext.request.contextPath}/resources/image/btn_photo_arrow.png)">
			</div>
			
			<div class="photo-list">
				<c:forEach items="${photos}" var="photo" varStatus="status" >
					<div class="btn photo-item" onclick="showPhoto('${photo.seq}', '${status.index}')"  
						style="background-image: url('${pageContext.request.contextPath}${photo.snapsht}')">
					</div>
				</c:forEach>
			</div>
			
			<div class="btn btn-right-list"  style="background-image: url(${pageContext.request.contextPath}/resources/image/btn_photo_arrow.png)">
			</div>
		</div>
	</div>
	
	<c:import url="../included/included_footer.jsp" charEncoding="UTF-8">
	</c:import>
	
</div>

</body>
</html>