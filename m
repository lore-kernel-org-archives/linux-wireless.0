Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45346 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYKOAfN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 19:35:13 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 16:35:13 -0800
Date: Fri, 14 Nov 2008 16:35:10 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Christian Lamparter <chunkeey@web.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 3/4] p54: protect against sudden firmware file changes
Message-ID: <20081115003510.GI27642@tesla> (sfid-20081115_013522_326014_4998F830)
References: <200811141941.56752.chunkeey@web.de> <1226700028.4120.28.camel@johannes.berg> <200811150054.30113.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200811150054.30113.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 03:54:29PM -0800, Christian Lamparter wrote:
> On Friday 14 November 2008 23:00:28 Johannes Berg wrote:
> > On Fri, 2008-11-14 at 19:41 +0100, Christian Lamparter wrote:
> > > Thanks to "p54: introduce new names for device firmwares"
> > > (325ca16910a380c...) people are now migrating away from the buggy firmwares.
> > > Of course this is a very good idea, but no one told them to unload the driver first.
> >
> > that seems weird. Doesn't the driver pretty much have to cache the
> > firmware anyway for suspend/resume?
> 
> well, that's odd. No one complained about this bug yet?!
> Even better, this bug/quirk is even present in the initial p54pci version that made it
> into the kernel. In fact it looks like its even present in the fullmac driver! Luis?

Umm, hey there's a shiny new driver called p54pci, I hear its maintainer
is really good with it and actually keeps it up to date and everything.

  Luis
