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

function toggleAddTagForm(w_id) {
    $('add_tag_form_' + w_id).toggle();

    var button = $('add_tag_fold_'+ w_id);

    if (button.text == '+') {
        $('add_tag_fold_'+ w_id).update('-');
    }
    else {
        $('add_tag_fold_'+ w_id).update('+');
    }
}

function toggleChangeWordFormForm(w_id) {
    $('change_word_form_form_' + w_id).toggle();

    var button = $('change_word_form_fold_'+ w_id);

    if (button.text == '+') {
        $('change_word_form_fold_'+ w_id).update('-');
    }
    else {
        $('change_word_form_fold_'+ w_id).update('+');
    }
}

function updateWord(idx, form) {
    $('word-' + idx).update(form);
}
