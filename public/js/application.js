function encryptMessage() {
    var password = $('#message-password').val();
    var message = $('#message-text').val();

    if(password){
        $('#message-text').val(GibberishAES.enc(message, password));
    }
    return false;
}
