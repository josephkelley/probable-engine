$(document).ready(function () {
  function handleRemoveField(e) {
    e.preventDefault();
    //will hide or remove, depending on class and upload group
    if($(".multi-upload-group").length > 1 || $(this).hasClass("multiUploadDeletePersistedField")) {
      $(this).parent().remove();
    } else {
      $(this).parent().hide(); //dont remove it, just hide it
    }
  }

  $("#multiUploadMoreFields").click(function (e) {
    e.preventDefault();
    if($(".multi-upload-group:visible").length === 0) {
      $(".multi-upload-group").show(); //we never deleted it, just hid it
    } else {
      $(".multi-upload-group").first().clone().appendTo("#multiUploadContainer"); //add new group

      //reset id's
      var num = $(".multi-upload-group").length-1; //index starting at 0
      var group = $(".multi-upload-group").last(); //the grouping we just created

      var fileInput = group.find('.multi-upload-file'); //find file input in the group
      fileInput.attr("name",fileInput.attr("name").replace(/\d/,num)); //change the number in the id
      fileInput.val(""); //set to null

      var descInput = group.find('.multi-upload-desc'); //find file desc in the group
      descInput.attr("name",descInput.attr("name").replace(/\d/,num)); //change the number in the id
      descInput.val(""); //set to null

      group.find("a[class='multiUploadDeleteField']").click(handleRemoveField) //append the click event
    }
  });

  $(".multiUploadDeleteField").click(handleRemoveField); //append the event to the first field
  $(".multiUploadDeletePersistedField").click(handleRemoveField); //append the event to the existing fields
});
