var uniForm = {
    uniform: function () {
        var fields = $$("form.uniForm input").concat($$("form.uniForm select")).concat($$("form.uniForm textarea"));
        forEach(fields, bind("addEvents", this));
    },

    addEvents: function (element) {
        connect(element, 'onblur', this.clearFocused);
//        connect(element, 'onfocus', this.clearFocused);
        connect(element, 'onfocus', this.setFocus);
    },

    setFocus: function () {
        forEach($$(".focused"), function (f) { f.className = f.className.replace(/\s+focused/g, '') });

        var parent = this;
        while (parent && !parent.className.match(/ctrlHolder/)) {
            parent = parent.parentNode;
        }

        if (parent) parent.className = parent.className + " focused";
    },

    clearFocused: function () {
        forEach($$(".focused"), function (f) { f.className = f.className.replace(/\s+focused/g, '') });
    }
};

addLoadEvent(function () { uniForm.uniform() });
