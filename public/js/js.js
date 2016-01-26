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


$('#testmail').click(function(){
    $.post( "/test/email", $( "#trainingrequest" ).serialize() );
    $('#training_sent_alert').show();
})





//uh-oh


// Your Client ID can be retrieved from your project in the Google
// Developer Console, https://console.developers.google.com
var CLIENT_ID = '315899277116-mpn9sgsbn0h3gcal95sumvh9prcf2k6n.apps.googleusercontent.com';

var SCOPES = ["https://www.googleapis.com/auth/calendar.readonly"];

/**
 * Check if current user has authorized this application.
 */
function checkAuth() {
    gapi.auth.authorize(
        {
            'client_id': CLIENT_ID,
            'scope': SCOPES.join(' '),
            'immediate': true
        }, handleAuthResult);
}

/**
 * Handle response from authorization server.
 *
 * @param {Object} authResult Authorization result.
 */
function handleAuthResult(authResult) {
    var authorizeDiv = document.getElementById('authorize-div');
    if (authResult && !authResult.error) {
        // Hide auth UI, then load client library.
        authorizeDiv.style.display = 'none';
        loadCalendarApi();
    } else {
        // Show auth UI, allowing the user to initiate authorization by
        // clicking authorize button.
        authorizeDiv.style.display = 'inline';
    }
}

/**
 * Initiate auth flow in response to user clicking authorize button.
 *
 * @param {Event} event Button click event.
 */
function handleAuthClick(event) {
    gapi.auth.authorize(
        {client_id: CLIENT_ID, scope: SCOPES, immediate: false},
        handleAuthResult);
    return false;
}

/**
 * Load Google Calendar client library. List upcoming events
 * once client library is loaded.
 */
function loadCalendarApi() {
    gapi.client.load('calendar', 'v3', listUpcomingEvents);
}

/**
 * Print the summary and start datetime/date of the next ten events in
 * the authorized user's calendar. If no events are found an
 * appropriate message is printed.
 */
function listUpcomingEvents() {
    var request = gapi.client.calendar.events.list({
        'calendarId': 'primary',
        'timeMin': (new Date()).toISOString(),
        'showDeleted': false,
        'singleEvents': true,
        'maxResults': 10,
        'orderBy': 'startTime'
    });

    request.execute(function(resp) {
        var events = resp.items;
        appendPre('Upcoming events:');

        if (events.length > 0) {
            for (i = 0; i < events.length; i++) {
                var event = events[i];
                var when = event.start.dateTime;
                if (!when) {
                    when = event.start.date;
                }
                appendPre(event.summary + ' (' + when + ')')
            }
        } else {
            appendPre('No upcoming events found.');
        }

    });
}

/**
 * Append a pre element to the body containing the given message
 * as its text node.
 *
 * @param {string} message Text to be placed in pre element.
 */
function appendPre(message) {
    var pre = document.getElementById('output');
    var textContent = document.createTextNode(message + '\n');
    pre.appendChild(textContent);
}





