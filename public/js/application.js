function encryptMessage() {
    var password = document.getElementsByName('password')[0].value;
    var message = document.getElementsByName('message[text]')[0].value;

    if(password){
        document.getElementsByName('message[text]')[0].value = GibberishAES.enc(message, password);
    }
    return false;
}
