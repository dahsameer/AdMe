// Add slideDown animation to Bootstrap dropdown when expanding.
$('.dropdown').on('show.bs.dropdown', function() {
    $(this).find('.dropdown-unroll').first().stop(true, true).slideDown();
}).on('hide.bs.dropdown', function() {
    $(this).find('.dropdown-unroll').first().stop(true, true).slideUp();
});
