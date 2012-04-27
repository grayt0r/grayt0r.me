(function() {

  $(function() {
    $('a[data-pjax]').pjax();
    return $('#click-me').click(function() {
      return alert('Boo!!');
    });
  });

}).call(this);
