Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761240AbYHOURY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 16:17:24 -0400
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted
	from commit 741b4fbc44
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200808152215.05761.chunkeey@web.de>
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net>
	 <200808152034.46346.chunkeey@web.de> <1218828375.3197.0.camel@localhost>
	 <200808152215.05761.chunkeey@web.de>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 22:17:16 +0200
Message-Id: <1218831437.3197.5.camel@localhost> (sfid-20080815_221743_121251_BABD8019)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-08-15 at 22:15 +0200, Chr wrote:

> hmm? has this something to do with the per STA TID in 
> 7.1.3.4.1 (802.11-2007) ?

yes

> Well the firmware (aka: LowerMAC) has some sort station
> database so there could be some room for that... maybe.

makes little sense since we don't tell it about stations, well, I dunno.

> (But yes, when I was playing with the AP/IBSS, 
> all beacon frames had a running sequence counter...

Maybe only non-QoS frames?

> maybe you can see this with a cx3110x in IBSS mode too?!)

we're supposed to be getting documentation on the lmac in there...

johannes

