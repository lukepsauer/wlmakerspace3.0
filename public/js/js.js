var userId;
var userName;
var userImg;
var userEmail;


function onSignIn(googleUser) {
    // Useful data for your client-side scripts:
    var profile = googleUser.getBasicProfile();
    console.log("ID: " + profile.getId()); // Don't send this directly to your server!
    userName = profile.getName();
    userImg = profile.getImageUrl();
    userEmail = profile.getEmail();
    // The ID token you need to pass to your backend:
    var id_token = googleUser.getAuthResponse().id_token;
    console.log("ID Token: " + id_token);
};

function clicky(){
    $.post("/test", {name: userName, email: userEmail});
}
function signOut() {
    var auth2 = gapi.auth2.getAuthInstance();
    auth2.signOut().then(function () {
        console.log('User signed out.');
        userId="";
        userName="";
        userImg="";
        userEmail="";
    });
}

$("#hiddenChangePass").hide();
/*$(".alert.alert-success.alert-dismissible.email").hide();*/
$('#coachlogin').click(function(){
    $('#mymodal').modal('show')
})

Mousetrap.bind('up up down down left right left right b a enter', function(e) {

    console.log("Hey! Konami! High Five!");
    $('.modal.fade.perms')
        .modal('show')
    ;
})

$('.datepicker').pickadate({
    min: +2,
    max: +18
});

$('.timepicker').pickatime({
        min: new Date(2015,3,20,10),
        max: new Date(2015,7,14,18,30)
});

$("#trainingrequest").validate();

$('#postCreate').validate();

$("#myModal").validate();

$('#newblogpost').click(function(){
    $('#postCreate').modal('show')
})


$('#showChangePass').click(function(){
    $('#hiddenChangePass').fadeIn();
})

$('.blogPost').readmore({
    speed: 75,
    lessLink: '<a href="#">Read less</a>'
})
$('.delete').click(function(){
    $('#postDelete').modal('show')
})
$('#openSuggest').click(function(){
    $('#suggestionModal').modal('show')
})


$('#sentemail').click(function(){
    console.log("Be this work wat?")
    $.post( "/test/email", $( "#trainingrequest" ).serialize() );
});

$(window).scroll(function() {

    var styledDiv = $('nav'),
        targetScroll = $('nav').position().top,
        currentScroll = $('html').scrollTop() || $('body').scrollTop();
        styledDiv.toggleClass('downNav', currentScroll >= targetScroll);
});













