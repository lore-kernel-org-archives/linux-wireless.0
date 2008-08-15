Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYHOVNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 17:13:41 -0400
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted
	from commit 741b4fbc44
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200808152306.38450.chunkeey@web.de>
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net>
	 <200808152215.05761.chunkeey@web.de> <1218831437.3197.5.camel@localhost>
	 <200808152306.38450.chunkeey@web.de>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 23:13:35 +0200
Message-Id: <1218834815.3197.7.camel@localhost> (sfid-20080815_231355_525342_F0A9CAFA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > we're supposed to be getting documentation on the lmac in there...
> Really?! Well, from my POV it would be better to kickstart FreeMAC,
> rather than writing a driver for these LMAC Firmwares... seriously!

Dunno. We have the header already: 
http://cx3110x.sipsolutions.net/Commands?action=AttachFile&do=view&target=lmac_longbow.h

johannes

