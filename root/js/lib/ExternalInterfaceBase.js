if (typeof(MochiKit) == "undefined") {
    throw("Required MochiKit 1.3 or above");
}
if (typeof(SWFObject) == "undefined") {
    throw("Required SWFObject");
}

// http://la.ma.la/blog/diary_200702152107.htm
Function.toNative = function(obj, method_name) {
    return function(){
        var params = [];
        for(var i=0;i<arguments.length;i++) params[i] = "_"+i;
        return Function(
            params.join(','),
            'this["'+method_name+'"]('+params.join(',')+')'
        ).apply(obj, arguments);
    }
}

var ExternalInterfaceClass = {
    callbacks: {},

    htmlLoaded: false,
    insert: function() {
        var so  = new SWFObject(this.swf, this.swfid, "1", "1", this.flashVersion || "9");
        var div = DIV();
        var div_wrapper = DIV({ style: { width:"0px", height:"0px", margin:"0", padding:"0", border:"none"} });
        if (!so.write(div)) {
            if (typeof(this["onOldPlayer"]) == "function") {
                this["onOldPlayer"](so.installedVer, so.getAttribute("version"));
            }
        }
        else {
            if (ExternalInterfaceClass.htmlLoaded) {
                document.body.appendChild(div_wrapper);
                div_wrapper.innerHTML = div.innerHTML;
            }
            else {
                div_wrapper.appendChild(div);
                document.write(div_wrapper.innerHTML);
            }

            var checkLoaded = function(self) {
                var as = navigator.userAgent.match(/MSIE/) ? window[self.swfid] : document[self.swfid];
                //console.log("checkload: ", self, as);
                if (as && typeof(as['ready']) == 'function') {
                    self['ready'] = true;
                    self['as'] = as;
                    if (self["onLoadEvent"]) self.onLoadEvent.callback();
                }
                else {
                    setTimeout(partial(arguments.callee, self), 100);
                }
            };
            setTimeout(partial(checkLoaded, this), 100);
        }
    },

    addLoadEvent: function(callback) {
        if (!this["onLoadEvent"]) {
            this["onLoadEvent"] = new Deferred();
        }
        this.onLoadEvent.addCallback(callback);
    }
};

addLoadEvent(function() { ExternalInterfaceClass.htmlLoaded = true });

