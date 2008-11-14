Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:48989 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYKNXyd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 18:54:33 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/4] p54: protect against sudden firmware file changes
Date: Sat, 15 Nov 2008 00:54:29 +0100
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200811141941.56752.chunkeey@web.de> <1226700028.4120.28.camel@johannes.berg>
In-Reply-To: <1226700028.4120.28.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811150054.30113.chunkeey@web.de> (sfid-20081115_005437_658038_229D5F8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 November 2008 23:00:28 Johannes Berg wrote:
> On Fri, 2008-11-14 at 19:41 +0100, Christian Lamparter wrote:
> > Thanks to "p54: introduce new names for device firmwares"
> > (325ca16910a380c...) people are now migrating away from the buggy firmwares. 
> > Of course this is a very good idea, but no one told them to unload the driver first.
> 
> that seems weird. Doesn't the driver pretty much have to cache the
> firmware anyway for suspend/resume?

well, that's odd. No one complained about this bug yet?!
Even better, this bug/quirk is even present in the initial p54pci version that made it
into the kernel. In fact it looks like its even present in the fullmac driver! Luis?

I guess, I have to leave it that way to provide "bug-to-bug" compatibility! ;-)

Regards,
	Chr
