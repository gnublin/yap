'use strict';

clickMainFrame();
errMsg();

function clickMainFrame() {
    var expandEl = document.querySelectorAll('.expand');
    var addNewEl = document.getElementById('addNew');
    if (addNewEl) {
        addNewEl.addEventListener('click', expand);
    }
    for (var e = 0; e < expandEl.length; e++) {
        expandEl[e].addEventListener('click', expand);
    }
}

function expand(){
    var toDisplayEl =  this.parentNode.nextElementSibling;
    if ( this.className == 'expand fa fa-plus' ) {
        this.className = 'expand fa fa-minus'
        var expandStatus = true;
    }
    else {
        this.className = 'expand fa fa-plus'
        var expandStatus = false;
    }
    toDisplayEl.style.display = expandStatus ? 'block' : 'none';
}

function errMsg() {

  var locationArray = location.search.split(/[?|&]/)
  var errMsgEl = document.getElementById('msgErr');
  for (var f = 0, g = locationArray.length; f < g; f++) {
    if (locationArray[f].match(/^msgErr*/)) {
      var msgCode = locationArray[f].split('=')[1];
      break;
    }
    else {
      msgCode = false;
    }
  }

  if (msgCode !== false) {
    if (msgCode > 0) {
      errMsgEl.style.backgroundColor = 'red';
    }
    else if (msgCode == '0') {
      errMsgEl.style.backgroundColor = 'green';
    }
    setTimeout(function(){errMsgEl.classList.toggle('fade')}, 3000)
  }

}

