$(document).ready(function () {
  var total = 0
  $(".add").click(function additem() {
    unique_id = this.id.slice(3)
    item = JSON.parse($("#card" + unique_id).attr('data-bs-whatever'))
    value = Number($("#item" + unique_id).val()) + 1
    $("#item" + unique_id).val(value)
    $("#item" + unique_id).html(value)
    if (value == 1) {
      renderhtml = "<div class='singleitem' id='cartitem" + unique_id + "'>"
      renderhtml += "<h1 id=\'cartname" + unique_id + "\' class='itemname'>" + item.name + "</h1>"
      renderhtml += "<p id=\'cartquan" + unique_id + "\' class='cartquantity btn-primary'>" + value + "</p>"
      renderhtml += "<p id=\'cartpric" + unique_id + "\' class='itemprice'>" + item.price + "</p>"
      renderhtml += "</div>"
      document.getElementById('itemsamount').insertAdjacentHTML('beforeend', renderhtml);
    }
    else {
      $("#cartquan" + unique_id).html(value)
    }
    total += item.price * value
    $(".totalcart").html(total)
  });

  $(".sub").click(function () {
    unique_id = this.id.slice(3)
    value = Number($("#item" + unique_id).val())
    value -= 1
    if (value <= 0) {
      var myobj = document.getElementById("cartitem" + unique_id);
      myobj.remove();
      value = 0
    }
    else {
      $("#cartquan" + unique_id).html(value)
    }
    $("#item" + unique_id).val(value)
    $("#item" + unique_id).html(value)
  });

});
