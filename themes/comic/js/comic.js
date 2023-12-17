function goFirst(){
  window.location.href = jQuery('.flippy-first a').attr('href');
}
function goLast(){
  window.location.href = jQuery('.flippy-last a').attr('href');
}
function goNext(){
  window.location.href = jQuery('.flippy-next a').attr('href');
}
function goPrevious(){
  window.location.href = jQuery('.flippy-previous a').attr('href');
}

document.addEventListener("DOMContentLoaded", function(event) { 
if(jQuery('body').hasClass('page-node-type-comic-entry')){
  jQuery('.field--name-field-publishing-date, h1').wrapAll('<div class="comicTitleDate">');
}
  if(jQuery('.flippy-first a').length == 0){
	  jQuery('#firstGrey').show();
	  jQuery('.navFirst').remove();
	  jQuery('.navPrevious').remove();
  }
  if(jQuery('.flippy-last a').length == 0){
	  jQuery('#lastGrey').show();
	  jQuery('.navLast').remove();
	  jQuery('.navNext').remove();
  }
  jQuery('map').imageMapResize();

jQuery('.comic-entry .social-sharing-buttons__button').each(function(index){
	var shareURL=jQuery(this).attr('href');
	if (index == 0) jQuery('.postFacebook').attr('href', shareURL);
  else if (index == 1) jQuery('.postTwitter').attr('href', shareURL);
  else jQuery('.postTumblr').attr('href', shareURL);
});


  
   jQuery('.blog-entry').each(function(){
        var blogTitle = jQuery(this).find('h2 a').text();
	jQuery(this).find('h2').remove();
	jQuery('.field--name-user-picture').eq(0).before('<span class="blogTitle">'+blogTitle+"</h2>");
   });

});

