Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55342 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbbGMISk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 04:18:40 -0400
Message-ID: <1436775517.3595.3.camel@sipsolutions.net> (sfid-20150713_101843_439674_4E4EF5B9)
Subject: Re: Q: iw - how to scan for a specific ssid / AP mode scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 13 Jul 2015 10:18:37 +0200
In-Reply-To: <559A3CCD.1050308@neratec.com>
References: <5596BDAB.4020001@neratec.com>
	 <1435948682.2059.41.camel@sipsolutions.net> <559A3CCD.1050308@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Ah, that explains it. Though, intuitively when providing an SSID to 
> scan for, I'd
> expect other networks seen not to be displayed. If this is of general 
> interest, I
> could work out some extension to iw and provide a related patch.

I don't think so - you're not providing "find these networks", you're
providing "send probe requests with these SSIDs", i.e. it's perfectly
valid to also say "" A B C to create 4 probe requests.

johannes

