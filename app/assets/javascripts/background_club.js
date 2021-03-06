$(document).on('change', 'input#club_image', function(event){
  $('#image-background-club').cropper('destroy');
  var input = this;
  var target = $(event.currentTarget);
  var file = target[0].files[0];
  var reader = new FileReader();
  var acceptFileTypes = /^image\/(jpg|png|jpeg|gif)$/i;
  var img_tag = target.parent().find('#preview_avatar').children('img');
  if(file['type'].length && !acceptFileTypes.test(file['type'])) {
      alert(I18n.t('js.file_type'));
      input.value = '';
      return false;
    }
  else{
    reader.onload = function(e){
      var img = new Image();
      img.src = e.target.result;
      $('#image-background-club').attr('src', img.src);
      $('.cropper-canvas img, .cropper-view-box img').attr('src', img.src);
      cropImage();
    };
    reader.readAsDataURL(file);
  }
});

$(document).on('change', '.radio-image', function(){
  id = $(this).attr('id').replace('radio-', '');
  img = $('#' + id).attr('src');
  var xhr = new XMLHttpRequest();
  xhr.open('GET', img, true);
  xhr.responseType = 'blob';
  var blob;
  xhr.onload = function(e) {
    var reader = new FileReader();
    blob = this.response;
    reader.onload = function(e){
      $('#image-background').attr('src', img);
      $('.cropper-canvas img, .cropper-view-box img').attr('src', img);
      cropImage();
    }
    reader.readAsDataURL(blob);
  };
  xhr.send();
});

function cropImage(){
  var $crop_x = $('input#club_image_crop_x'),
    $crop_y = $('input#club_image_crop_y'),
    $crop_w = $('input#club_image_crop_w'),
    $crop_h = $('input#club_image_crop_h');
  $('#image-background-club').cropper({
    viewMode: 1,
    aspectRatio: 1,
    background: false,
    zoomable: false,
    getData: true,
    aspectRatio: 2.9,
    built: function () {
      var croppedCanvas = $(this).cropper('getCroppedCanvas', {
        width: 100,
        height: 100
      });
      croppedCanvas.toDataURL();
    },
    crop: function(data) {
      $crop_x.val(Math.round(data.x));
      $crop_y.val(Math.round(data.y));
      $crop_h.val(Math.round(data.height));
      $crop_w.val(Math.round(data.width));
    }
  });
  $('#image-background').cropper({
    viewMode: 1,
    aspectRatio: 1,
    background: false,
    zoomable: false,
    getData: true,
    aspectRatio: 3.2,
    built: function () {
      var croppedCanvas = $(this).cropper('getCroppedCanvas', {
        width: 100,
        height: 100
      });
      croppedCanvas.toDataURL();
    },
    crop: function(data) {
      $crop_x.val(Math.round(data.x));
      $crop_y.val(Math.round(data.y));
      $crop_h.val(Math.round(data.height));
      $crop_w.val(Math.round(data.width));
    }
  });
}
