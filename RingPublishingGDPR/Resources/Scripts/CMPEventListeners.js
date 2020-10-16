// Events from JS Consent Management Platform

// Handler for function timer
var cmpInterval;

// Function adding event listeners to CMP
function addCMPListeners() {

    // If we have CMP object -> add handlers
    if (window.__tcfapi != undefined) {

        // Add listeners
        try {
            window.__tcfapi('addEventListener', 2, function(data, success) {
                webkit.messageHandlers.cmpEvents.postMessage({"cmpEventStatus": data.eventStatus});
            });

            // Stop our function timer after adding event listeners
            clearInterval(cmpInterval);

        } catch (error) {
            webkit.messageHandlers.cmpEvents.postMessage({"cmpEventStatus": "error"});
        }
    }
}

// Start our function timer when window loads
window.onload = function() {
    cmpInterval = setInterval(addCMPListeners, 100);
};
