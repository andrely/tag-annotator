// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showError(msg) {
    $(feedback).update(msg);
}

function tagToggleSuccessHandler(request, tag_id, row_id) {
    if (request.statusText == 0) {
        tagToggleFailureHandler(request, tag_id);
    }
    else {
        new Effect.Highlight(row_id,
                             {startcolor: '#88ff88',
                              endcolor: '#114411',
                              duration: 0.5});
    }
}

function tagToggleFailureHandler(request, tag_id) {
    showError(request.status + ' ' + request.responseText);
    $(tag_id).checked = !$(tag_id).checked;
}

/**
 *
 * Toggles showing/hiding an element and updates the button to show the state
 * of the element.
 *
 * Used by sentences/_fold_out_button.erb
 *
 * @param elt_id ID of element to show/hide
 * @param button_id The ID og the button (div).
 */
function toggleEltFromButton(elt_id, button_id) {
    $(elt_id).toggle();

    var button = $(button_id);

    if (button.text == '+') {
        $(button_id).update('-');
    }
    else {
        $(button_id).update('+');
    }
}

function updateWord(idx, form) {
    $('word-' + idx).update(form);
}
