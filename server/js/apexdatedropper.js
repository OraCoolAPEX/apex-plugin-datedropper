// APEX DateDropper Functions
// Author: Erick Diaz
// Version: 1.0.2

//Global Namespace
var apexDateDropper = {
  initDateDropper: function(pItemId, pOptions, pLogging) {
    var vOptions = pOptions;
    var vLogging = pLogging;
    var vDefaultDate = vOptions.defaultDate;
    var vDisabledDays = vOptions.disabledDays;
    var vFormat = vOptions.format;
    var vFx = vOptions.fx;
    var vFxMobile = vOptions.fxMobile;
    var vInitSet = vOptions.initSet;
    var vLang = vOptions.lang;
    var vLargeMode = vOptions.largeMode;
    var vLargeDefault = vOptions.largeDefault;
    var vLock = vOptions.lock;
    var vJump = vOptions.jump;
    var vMaxYear = vOptions.maxYear;
    var vMinYear = vOptions.minYear;
    var vModal = vOptions.modal;
    var vTheme = vOptions.theme;
    var vTranslateMode = vOptions.translateMode;

    if (vLogging) {
      console.log(pItemId + ' - apexDateDropper.defaultDate: ' + vDefaultDate);
      console.log(pItemId + ' - apexDateDropper.disabledDays: ' + vDisabledDays);
      console.log(pItemId + ' - apexDateDropper.format: ' + vFormat);
      console.log(pItemId + ' - apexDateDropper.fx: ' + vFx);
      console.log(pItemId + ' - apexDateDropper.fxMobile: ' + vFxMobile);
      console.log(pItemId + ' - apexDateDropper.initSet: ' + vInitSet);
      console.log(pItemId + ' - apexDateDropper.lang: ' + vLang);
      console.log(pItemId + ' - apexDateDropper.largeMode: ' + vLargeMode);
      console.log(pItemId + ' - apexDateDropper.largeDefault: ' + vLargeDefault);
      console.log(pItemId + ' - apexDateDropper.lock: ' + vLock);
      console.log(pItemId + ' - apexDateDropper.jump: ' + vJump);
      console.log(pItemId + ' - apexDateDropper.maxYear: ' + vMaxYear);
      console.log(pItemId + ' - apexDateDropper.minYear: ' + vMinYear);
      console.log(pItemId + ' - apexDateDropper.modal: ' + vModal);
      console.log(pItemId + ' - apexDateDropper.theme: ' + vTheme);
      console.log(pItemId + ' - apexDateDropper.translateMode: ' + vTranslateMode);
    }

    $('#' + pItemId).dateDropper();

    var vDateDropperId = $('#' + pItemId).data('id');

    $('#' + vDateDropperId + ' .pick-submit').on('touchend mouseup', function() {
      $('#' + pItemId).trigger('apex-datedropper-change');
    });
  }
};