'use strict';

clickToolbar("edit");
clickToolbar("delete");
clickGenPassAdd();
clickAddEntry();

function clickGenPassAdd() {
    var genPass = document.querySelector('.pass-gen-add');
    if (genPass) {
        genPass.addEventListener('click',genPassword);
    }
}

function clickToolbar(action) {
    var actionEl = document.querySelectorAll('.' + action);
    for (var e = 0; e < actionEl.length; e++) {
        actionEl[e].addEventListener('click', function() {
            switch (action) {
                case 'edit':
                    var editableEl = this.parentNode.parentNode.querySelectorAll('.editable');
                    for (var f = 0; f < editableEl.length; f++) {
                        editableEl[f].removeAttribute('disabled')
                    }
                    var submitEl = this.parentNode.parentNode.querySelectorAll('.subLdap');
                    var passwordEl = this.parentNode.parentNode.querySelectorAll('.pass-gen');
                    submitEl[0].style.visibility = 'visible';
                    passwordEl[0].style.visibility = 'visible';
                    passwordEl[0].addEventListener('click',genPassword);

                    break;
                case 'delete':
                    document.body.addEventListener("keyup", function(e){ if(e.keyCode == 27) document.location.reload(); }, false);
                    var whoEl = this.parentNode.getAttribute('data-cn');
                    var lightbox = document.createElement("div");
                    var dimmer = document.createElement("div");

                    dimmer.className = 'dimmer';
                    lightbox.id = 'lightbox';

                    document.body.appendChild(dimmer);
                    document.body.appendChild(lightbox);

                    lightbox.style.visibility = 'visible';
                    lightbox.style.top = '30%';
                    lightbox.style.left = '30%';
                    
                    lightbox.innerHTML = '\
                        <p>Are you sure you want to delete "'+ whoEl +'"?</p>\
                        <form method="get" action="/ldapManage" >\
                        <input class="inpLdap" type="hidden" name="actionTo" value="delete" />\
                        <input class="inpLdap" type="hidden" name="cn" value="' + whoEl + '" />\
                        <div class="divDel"><input class="subDelLdap" type="submit" value="yes" />\
                        <button class="subDelLdap cancel" >no</button></div>\
                        </form>\
                        ';

                    var cancelEl = lightbox.querySelector('.cancel');
                    cancelEl.addEventListener('click', function(event){
                        event.preventDefault();
                        var dimmer = document.querySelectorAll('.dimmer')[0]
                        var lightbox = document.getElementById('lightbox')
                        document.body.removeChild(lightbox);
                        document.body.removeChild(dimmer);
                    })
            }
        });
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

function requiredEnable(inputEl, defaultClass) {
    if (inputEl.value.length > 0) {
        inputEl.parentNode.className = defaultClass;
    }
    else {
        inputEl.parentNode.className = defaultClass + " lab-required";
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

function checkInputValue() {

}
