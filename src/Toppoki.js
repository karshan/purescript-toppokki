var puppeteer = require("puppeteer");

exports.puppeteer = puppeteer;

exports._launch = function(options) {
  return function() {
    return puppeteer.launch(options);
  };
};

exports._newPage = function(browser) {
  return function() {
    return browser.newPage();
  };
};

exports._goto = function(url, page) {
  return function() {
    return page.goto(url);
  };
};

exports._close = function(browser) {
  return function() {
    return browser.close();
  };
};

exports._content = function(page) {
  return function() {
    return page.content();
  };
};

exports._content = function(page) {
  return function() {
    return page.content();
  };
};

exports._screenshot = function(options, page) {
  return function() {
    return page.screenshot(options);
  };
};

exports._pdf = function(options, page) {
  return function() {
    return page.pdf(options);
  };
};

exports._on = function(event, callback, page) {
  return page.on(event, callback);
};

exports._pageWaitForSelector = function(selector, options, page) {
  return function() {
    return page.waitForSelector(selector, options);
  };
};

exports._focus = function(selector, page) {
  return function() {
    return page.focus(selector);
  };
};

exports._type = function(selector, content, options, page) {
  return function() {
    return page.type(selector, content, options);
  };
};

exports._click = function(selector, page) {
  return function() {
    return page.click(selector);
  };
};

exports._waitForNavigation = function(options, page) {
  return function() {
    return page.waitForNavigation(options);
  };
};

exports._getLocationHref = function(page) {
  return function() {
    return page.evaluate(function() {
      return window.location.href;
    });
  };
};

exports._unsafeEvaluateStringFunction = function(string, page) {
  return function() {
    return page.evaluate(string);
  };
};

exports._setUserAgent = function(userAgent, page) {
  return function() {
    return page.setUserAgent(userAgent);
  };
};

exports._allowDownloads = function(downloadDir, page) {
  return function() {
    page._client.send('Page.setDownloadBehavior', {
      behavior: 'allow',
      downloadPath: downloadDir
    });
  }
}

exports._setViewport = function(options, page) {
  return function() {
    return page.setViewport(options);
  };
}

exports._frames = function(page) {
  return function() {
    return page.frames();
  };
}

exports._name = function(frame) {
  return function() {
    return frame.name();
  };
}

exports._frameWaitForSelector = function(selector, options, frame) {
  return function() {
    return frame.waitForSelector(selector, options);
  };
}

exports._frameSelect = function(selector, frame) {
  return function() {
    return frame.$(selector);
  };
}

exports._elementClick = function(e) {
  return function() {
    return e.click();
  };
}

exports._pageType = function(string, page) {
  return function() {
    return page.keyboard.type(string);
  };
}

exports._addResponseListener = function(cb, page) {
  return function() {
    page.on('response', cb);
  };
}

exports._removeResponseListener = function(cb, page) {
  return function() {
    page.removeListener('response', cb);
  };
}

exports.responseListener = function (fn) {
  return function () {
    return function (event) {
      return fn(event)();
    };
  };
};

exports.request = function(response) {
	return function() {
		return response.request();
	}
}

exports.reqUrl = function(request) {
	return function() {
		return request.url();
	}
}

exports._cookies = function(page) {
	return  function() {
		return page.cookies();
	}
}
