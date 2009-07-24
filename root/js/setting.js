(function () {
     function select(radio) {
         switch (radio.value) {
         case "no":
             hideElement("password_auth_field");
             hideElement("secret_auth_field");
             break;
         case "password":
             hideElement("secret_auth_field");
             showElement("password_auth_field");
             break;
         case "secretkey":
             hideElement("password_auth_field");
             showElement("secret_auth_field");
             break;
         }
     }

     function selectHandler() {
         select(this);
     }

     var radios = $$(".radioInput");
     for (var i = 0; i < radios.length; i++) {
         connect( radios[i], "onclick", selectHandler );
         if (radios[i].checked) select(radios[i]);
     }
})();

