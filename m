Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50310 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYLHPuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 10:50:25 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Subject: Re: [p54]: oops in p54_rx
Date: Mon, 8 Dec 2008 16:50:25 +0100
Cc: linux-wireless@vger.kernel.org
References: <20081208074904.GA28269@roarinelk.homelinux.net> <200812081624.21964.chunkeey@web.de> <20081208153208.GC4221@roarinelk.homelinux.net>
In-Reply-To: <20081208153208.GC4221@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812081650.26024.chunkeey@web.de> (sfid-20081208_165030_099479_D84F22E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 December 2008 16:32:08 Manuel Lauss wrote:
> On Mon, Dec 08, 2008 at 04:24:21PM +0100, Christian Lamparter wrote:
> > On Monday 08 December 2008 15:47:27 Manuel Lauss wrote:
> > [...]
> > > > > But what I can do is to stop the driver from oopsing...
> > > > >  
> > > > > I guess a check to see if the device mode is set to something else than 
> > > > > "NL80211_IFTYPE_UNSPECIFIED" and in p54_rx(_data) should prevent the oops.
> > > > > maybe we I should add a hex_dump as well.
> > > > 
> > > > patch attached... tell me what it does on your dev.
> > > 
> > > Thank you,  but I think the card is faulty... it doesn't work even on winxp
> > > ("device cannot be started Code 10"-error).  Do you still want me to test
> > > the patch?
> > Did you try the card in the same system with 4Gb and with the original SMC driver?
> > Well, either way... you could "confirm" that doesn't crash anymore ;-).
> 
> Tested on another machine with 1gb ram. It doesn't crash anymore.  If you're
> still interested, the log output is here  http://mlau.at/files/p54log
> 
interesting, the "logged" data has about the correct size.
But the data is totally screwed up.

So, yes you can kick it into the bin if you want to.

Regards,
	Chr
