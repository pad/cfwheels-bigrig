<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<style>
.bigrig.flash { background: #FFF7F9; border: solid 1px #900; padding: 10px 25px; overflow:auto; margin: 25px 0; }
.bigrig.flash pre { width: 95%; }

.properties { text-align: right; width: 400px; }
.properties .item { margin: 5px 0 10px; padding: 20px 20px 10px; }
.properties label { display: block; font-weight: bold; padding: 2px 5px 4px; }
.properties label input { margin: 0 0 0 4px; width: 250px; }

.properties .template { display: none; }

#content a.help { float: right; font-weight: bold; text-decoration: none; margin-top: 10px; padding: 2px 5px; }

.odd { background: #f1f1f1; }
thead { font-size: 1.3em; }

.addApp.docs h3 { cursor: pointer; margin-bottom: 10px; }
#content h3 a { text-decoration: none; }
#content h3 a:hover { background: #ddd; }
</style>

<script>
;(function(){
	$(function(){
		$(".details:not(.show)").hide();
		$(".addApp.docs h3 a,.addApp.docs .tree").click(function(){
			$(this).parents("h3,p").next(".details").slideToggle(400);
		});
	
		$(".properties a.add").click(function(){
			var item = $(".properties .template").clone().removeClass("template");
			$(".properties .item:last").after(item);
			
			$(".properties .item").removeClass("odd");
			$(".properties .item:odd").addClass("odd");
			
			return false;
		});
	});
})(jQuery);
</script>