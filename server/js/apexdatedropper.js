//Global Namespace
var apexDateDropper = {
  initDateDropper: function(pItemId, pOptions, pLogging) {
    $('#' + pItemId).dateDropper();

    var vDateDropperId = $('#' + pItemId).data('id');
    
    var vUserAgent = function() {
      if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))
        return true;
      else
        return false;
    };

    var vTouchEvent = vUserAgent() ? 'touchstart' : 'mousedown';

    $(apex.gPageContext$).on(vTouchEvent, 'div#' + vDateDropperId + '.datedropper.picker-focus .pick-submit', function() {
      $('#' + pItemId).trigger('apex-datedropper-change');
    });
  }
};