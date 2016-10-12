// function notify() {
//     alert( "clicked" );
// }
// $( "button" ).on( "click", notify );

function encryptMessage() {
    var password = document.getElementsByName("password")[0].value;
    var message = document.getElementsByName("message[text]")[0].value;

    if(password){
        var encrypted = CryptoJS.AES.encrypt(message, password);
        document.getElementsByName("message[text]")[0].value = encrypted.toString();
        // document.getElementsByName("message[text]")[0].value = sjcl.encrypt(password, message);
        //
        // document.getElementsByName("message[text]")[0].value = GibberishAES.enc(message, password);
    }
    // var ckey = $("#cryptonkey").val();
    // var y=document.getElementById(control).value;
    // var encrypted = CryptoJS.AES.encrypt(y, ckey);
    // document.getElementById("crypton").value=encrypted;
    return false;
}

// $(function() {
//     $("#check-pass-form").submit(function(e){
//         e.preventDefault();
//
//         var transmittedData = {};
//         transmittedData.password = $('input[name="password"]').val();
//         transmittedData.link = $('input[name="link"]').val();
//
//         $.ajax({
//             type: "POST",
//             url: "/messages/password",
//             data: transmittedData,
//             success: function(){
//                 debugger;
//                 $("#message").html("Successfully registered")
//             },
//             error: function(){
//                 debugger;
//                 $("#message").html("Not Successful")
//             }
//         });
//     });
// });
// function checkPassword() {
//     debugger;
//
//
//     // event.preventDefault();
//
//     var transmittedData = {};
//     transmittedData.password = $('input[name="password"]').val();
//     transmittedData.link = $('input[name="link"]').val();
//
//     apiConnect("http://localhost:9292/messages/password", "POST", transmittedData, function(error, returnedData){
//         debugger;
//         if (error){
//             var data = JSON.parse(error.data);
//             var html = "<h2 class='text-danger center'>" + data.message + "</h2>";
//             var form = $("#loginForm");
//             if(!form.next().length){
//                 form.after(html);
//             }
//         }else{
//             currentUser = returnedData.data.token;
//             main();
//         }
//     });
//     return false;
// }
//
// function apiConnect (url, method, data, callback){
//     debugger;
//     var returnedData = {};
//     var responsedObject = {};
//
//     responsedObject.url = url;
//     responsedObject.dataType = "json";
//     responsedObject.contentType = "application/json;charset=UTF-8";
//     responsedObject.data = JSON.stringify(data);
//     responsedObject.type = method;
//
//     responsedObject.success = function (data, textStatus, xhr) {
//         debugger;
//         returnedData.status = xhr.status;
//         returnedData.data = data;
//         returnedData.textStatus = textStatus;
//         callback(null, returnedData);
//     };
//
//     responsedObject.error = function (xhr) {
//         debugger;
//         returnedData.status = xhr.status;
//         returnedData.data = xhr.responseText;
//         callback(returnedData);
//     };
//     debugger;
//     $.ajax(responsedObject);
// }
