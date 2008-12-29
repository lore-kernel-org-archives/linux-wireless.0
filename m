Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([67.18.34.4]:37115 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752621AbYL2Wk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 17:40:28 -0500
Received: from 96-26-251-53.sea.clearwire-dns.net ([96.26.251.53]:59723 helo=Hydra.darkmatter.org)
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LHQgE-0004nB-KC
	for linux-wireless@vger.kernel.org; Mon, 29 Dec 2008 16:33:46 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Setting 'n' or 'a' Mode, and WPA2?
Date: Mon, 29 Dec 2008 14:33:46 -0800
References: <200812270706.56478.Info@delphi-real-estate.com> <200812291010.25373.Info@delphi-real-estate.com> <1ba2fa240812291359r68325b34ycfaad8f51d922a4b@mail.gmail.com>
In-Reply-To: <1ba2fa240812291359r68325b34ycfaad8f51d922a4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812291433.46427.Info@delphi-real-estate.com> (sfid-20081229_234046_605024_06F8F07C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Monday 29 December 2008 13:59:19 Tomas Winkler wrote:
> > How do you set only 5GHz 'n' mode?  WPA2?
> 
> Just connect to 11n access point configured with WPA2 on 5GHz band.

Of course, why didn't I think of that.  That's like saying, "To make pancakes, make pancakes."

My goal is to set /etc/network/interfaces to specifically configure the 4965AGN card for 5GHz 'n' mode *only* and WPA2.  I can't find any documentation on setting 'n' mode, nor WPA2 specifically.

I'd like no broadcast of SSID, which I have working now on 'g' but don't know whether it's possible in 5GHz 'n'.  And I'd like cloaked traffic and as little handshake traffic as possible, although much of this seems impossible now with as little as is known about configuration.

I'd just be happy with 5GHz 'n' mode and WPA2.  Isn't there any documentation?


