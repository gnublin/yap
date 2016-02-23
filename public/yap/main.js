'use strict';

clickMainFrame();
clickAddEntry();
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

function genPassword(event) {
    event.preventDefault();
    var passwordEl = this.parentNode.querySelectorAll('.password')[0];
    var passwordClearEl = this.nextElementSibling;
    var genPass = document.createElement('script');
    var formEl = passwordEl.parentNode.parentNode.querySelectorAll('.required')
    genPass.src = "/genPass";
    genPass.onload = function() {
        passwordClearEl.innerHTML = 'generated: '+ password;
        passwordEl.value = passwordMD5;
        document.body.removeChild(this);
        if (passwordEl.parentNode.className.match('addLdap') ) {
            requiredEnable(passwordEl, "addLdap password");
            actionAddEntry(formEl);
        }
    }
    document.body.appendChild(genPass);
}

function actionAddEntry(formEl) {
    var addEntryEl = document.getElementById('addEntry');
    var remove;
    var checkbox = false;
    var checkCheckbox;
        for (var u=0, r=formEl.length; u<r; u++) {
        var formElType = formEl[u].getAttribute('type')
        if ((formElType == 'text') || (formElType == 'password')) {
            if ( formEl[u].value.length > 0 ) {
                remove = true ;
            }
            else {
                remove = false
                break;
            }
        }
        else if  (formElType == 'checkbox') {
            checkbox = true;
            if (formEl[u].checked === true ) {
                   checkCheckbox = true;
                    break;
            }
            else {
                   checkCheckbox = false;
            }
        }
    }

    if ((checkbox === true) && (checkCheckbox === true )) {
        remove = true;
    }
    else if ((checkbox === true) && (checkCheckbox === false )) {
        remove = false;
    }

    if ( remove == true ) {
        addEntryEl.removeAttribute('disabled');
    }
    else {
        addEntryEl.setAttribute('disabled',true);
    }
}

function requiredEnable(inputEl, defaultClass) {
    if (inputEl.value.length > 0) {
        inputEl.parentNode.className = defaultClass;
    }
    else {
        inputEl.parentNode.className = defaultClass + " lab-required";
    }
}


function clickGenPassAdd() {
    var genPass = document.querySelector('.pass-gen-add');
    if (genPass) {
        genPass.addEventListener('click',genPassword);
    }
}

function clickAddEntry() {
    var addEntryEl = document.getElementById('addEntry');
    var formEl = addEntryEl.parentNode.parentNode.querySelectorAll('.required')
    for (var u=0, r=formEl.length; u<r; u++) {
        var formElType = formEl[u].getAttribute('type')

        if (formElType == 'text')
        {
            formEl[u].addEventListener('input', function() {
                requiredEnable(this, "addLdap");
                actionAddEntry(formEl);
            });
        }
        else if (formElType == 'password')
        {
            formEl[u].addEventListener('input', function() {
                if (this.value.length > 0) {
                    this.parentNode.className = "addLdap";
                }
                else {
                    this.parentNode.className = "addLdap password lab-required";
                }
                actionAddEntry(formEl);

            });
        }
        else if (formElType == 'checkbox') {
            formEl[u].addEventListener('change', function() {
                var listEl = formEl
                var checkOne=[];
                for (var p=0, q=listEl.length; p<q; p++) {
                    if (listEl[p].checked === true ){
                        checkOne.push(listEl[p])
                    }
                }

                if (checkOne.length > 0) {
                    this.parentNode.parentNode.className = "addLdap";
                }
                else {
                    this.parentNode.parentNode.className = "addLdap lab-required";
                }

                actionAddEntry(formEl);
            });
        }
    }
}

function checkInputValue() {

}
