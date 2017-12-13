// with some inspiration from: https://github.com/fightforthefuture/battleforthenet-widget
(function () {
  var iframe_path = 'break-the-net.html'
  function injectCSS (id, css) {
    var style = document.createElement('style');
    style.type = 'text/css';
    style.id = id;
    if (style.styleSheet) style.styleSheet.cssText = css;
    else style.appendChild(document.createTextNode(css));
    document.head.appendChild(style);
  }
  function createIframe (id, src) {
    var wrapper = document.createElement('div');
    wrapper.id = '_ktn_wrapper';
    var iframe = document.createElement('iframe');
    iframe.id = id;
    iframe.src = src;
    iframe.frameBorder = 0;
    iframe.allowTransparency = true;
    wrapper.appendChild(iframe);
    document.body.appendChild(wrapper);
    return wrapper;
  }
  function onDomContentLoaded() {
    injectCSS('_ktn_iframe_css', '#_ktn_wrapper { position: fixed; left: 0px; top: 0px; width: 100%; height: 100%; z-index: 20000; -webkit-overflow-scrolling: touch; overflow-y: auto; } #_ktn_iframe { width: 100%; height: 100%;  }');
    createIframe('_ktn_iframe', iframe_path)
  }
  switch(document.readyState) {
    case 'complete':
    case 'loaded':
    case 'interactive':
      onDomContentLoaded();
      break;
    default:
      if (typeof document.addEventListener === 'function') {
        document.addEventListener('DOMContentLoaded', onDomContentLoaded, false);
      }
  }
})();
