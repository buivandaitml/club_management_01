jQuery(document).ready(function($) {
  $(document).on('keyup', '#organization_club_search', function() {
    $.get($('#organization_club_form').attr('action'),
      $('#organization_club_form').serialize(), null, 'script');
   });
});
