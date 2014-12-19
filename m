Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45782 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaLSKF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 05:05:29 -0500
Message-ID: <1418983525.1889.2.camel@sipsolutions.net> (sfid-20141219_110533_089399_DE96BADC)
Subject: Re: [RFC V2] cfg80211: Add feature flag for 4-way handshake offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Date: Fri, 19 Dec 2014 11:05:25 +0100
In-Reply-To: <5493F6E5.5060907@broadcom.com>
References: <1418935344-22159-1-git-send-email-arend@broadcom.com>
	 <1418980707.1889.1.camel@sipsolutions.net> <5493F34A.4040500@broadcom.com>
	 <5493F6E5.5060907@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-12-19 at 10:59 +0100, Arend van Spriel wrote:

> Looking at this again I wonder if it would be of value to have this as 
> NL80211_EXT_FEATURES_ATTR_LEN in nl80211.h so user-space can check the 
> nla_len() against it and detect API in-compatibility. Just can not use 
> DIV_ROUND_UP() in that case. What's your opinion?

Well, userspace must not check it since it should be compatible with new
kernels ... That was kinda my original point about not liking it in the
header to start with :)

johannes

