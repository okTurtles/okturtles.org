var pop = Popcorn.smart( "#video", [ "https://www.youtube.com/embed/7QLaKW8ABy4?rel=0&amp;controls=0&amp;showinfo=0&vq=hd720", "http://vimeo.com/100433057" ] );
pop.preload( false );
pop.load(false);

$(document).ready(function() {
  $('#play-video').on('click', function(ev) {
    $(this).hide();
    pop.play();
    $('#video-p').show();
    $('#vw').addClass('video-wrapper');
 
  });
});