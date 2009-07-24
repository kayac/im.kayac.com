if (typeof(ExternalInterfaceClass) == "undefined") {
    throw("Required ExternalInterfaceBase.js");
}

var Uploader = function() {
    bindMethods(this);
    this.initialize.apply(this, arguments);
};

update(Uploader, ExternalInterfaceClass, {
    swf: "/swf/Uploader.swf",
    swfid: "externalUploader",
    id: 0,
    counter: counter(),
    instances: {},
    flashVersion: 9
});

Uploader.prototype = {
    id: null,
    callbacks: {},

    initialize: function() {
        this.id = ++(Uploader.id);
        Uploader.as.createNewFileObject(this.id);
        Uploader.instances[this.id] = this;
    },

    call: function(method) {
        var f    = Function.toNative(Uploader.as, method);
        var args = [this.id].concat( list(arguments).slice(1) );
        return f.apply(null, args);
    },

    browse: function() {
        this.call("browse");
    },

    upload: function(url, params) {
        this.call("upload", url, params);
    },

    callback: function(event) {
        var callbacks = this.callbacks[event] || [];
        var args = list(arguments).slice(1);

        for (var i = 0; i < callbacks.length; i++) {
            callbacks[i].apply(this, args);
        }
    },

    addCallback: function(event, f) {
        if(!this.callbacks[event]) this.callbacks[event] = [];
        this.callbacks[event].push(f);
    },

    addCallbacks: function(callbacks) {
        for (var event in callbacks) {
            this.addCallback(event, callbacks[event]);
        }
    }
};

addLoadEvent( bind("insert", Uploader) );
