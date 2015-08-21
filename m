Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40353 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbbHUKQ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 06:16:28 -0400
Message-ID: <1440152186.2107.14.camel@sipsolutions.net> (sfid-20150821_121645_953932_01D78771)
Subject: Re: linux-only "freshness" auth problem??
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Tokarev <mjt@tls.msk.ru>, linux-wireless@vger.kernel.org
Date: Fri, 21 Aug 2015 12:16:26 +0200
In-Reply-To: <55D6F0DB.5050505@msgid.tls.msk.ru> (sfid-20150821_114437_353307_BC6FA2E1)
References: <55D6F0DB.5050505@msgid.tls.msk.ru>
	 (sfid-20150821_114437_353307_BC6FA2E1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-08-21 at 12:35 +0300, Michael Tokarev wrote:
> 
> Aug 21 11:31:49 x200la kernel: wlan0: authenticated
> Aug 21 11:31:49 x200la kernel: wlan0: waiting for beacon from c0:4a:00:49:1b:f2

Do you see any *kernel* messages after this? I'm half expecting to see
that the beacon never arrives, or something like that?

Are the hotels running similar equipment perhaps? If rebooting the AP
helps then perhaps the APs aren't actually beaconing quite properly -
maybe you could put the card into sniffer mode (monitor mode) and
capture what's going on over the air for a bit after this happened?

johannes
