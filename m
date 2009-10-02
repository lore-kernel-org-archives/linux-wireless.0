Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36380 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752075AbZJBLpz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 07:45:55 -0400
From: Malte Gell <malte.gell@gmx.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Fri, 2 Oct 2009 13:45:55 +0200
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	"Hin-Tak Leung" <hintak.leung@gmail.com>
References: <200910011654.10963.chunkeey@googlemail.com> <200910020852.36427.malte.gell@gmx.de> <200910021246.34699.chunkeey@googlemail.com>
In-Reply-To: <200910021246.34699.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200910021345.55567.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Christian Lamparter <chunkeey@googlemail.com> wrote

> > The Netgear (WN?) 111 even only has one blue LED as far as I know.
> 
> the question is if it's the only device with this deficit, or not?

Is it feasable to write to the well known stick makers (Netgear, AVM, 
Belkin,Asus...) and just ask them? 
> 
> > > FYI: you can assign the LEDs under "/sys/class/leds/"
> > Very good to know. This needs a udev rule, right?
> 
> yes, should be possible one way or another...
 
> If you do find an easy ACTION== rule, then let us know!

Do I hear irony? Is it not easy? Isn't it just a link that needs to be made / 
changed? Does it matter, when to do this, e.g. after the module ist loaded or 
the network system is started?
 
> > But, what about a USB ID based decission in the driver how to handle the
> > LED? I have a Fritz WLAN N, USB ID:  057c:8401
> 
> The first post had a patch attached:
> http://patchwork.kernel.org/patch/50977/

Have not tried it, is it well tested? If it works, will the patch become 
official part of compat-wireless?

Regards
Malte
