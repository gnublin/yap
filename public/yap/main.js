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

  var errMsgEl = document.getElementById('msgErr');
  var errMsgContent = document.getElementById('msgContent').innerHTML;
  if (errMsgContent) {
    if (errMsgContent.match(/^OK*/)) {
      errMsgEl.style.backgroundColor = 'green';
    }
    else if (errMsgContent.match(/^NOK*/)) {
      errMsgEl.style.backgroundColor = 'red';
    }
    setTimeout(function(){errMsgEl.classList.toggle('fade')}, 3000)
  }

}

