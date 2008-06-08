Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:42188 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbYFHUDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 16:03:46 -0400
From: Chr <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054 =?utf-8?q?usb=09adapter?=
Date: Sun, 8 Jun 2008 22:03:41 +0200
Cc: Ivo Couckuyt <iv0co@yahoo.co.uk>, linux-wireless@vger.kernel.org
References: <47AF79DA.10204@yahoo.co.uk> <4849A6D4.2090904@yahoo.co.uk> <1212926054.698.36.camel@johannes.berg>
In-Reply-To: <1212926054.698.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082203.42238.chunkeey@web.de> (sfid-20080608_220352_184640_F810B8F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 June 2008 13:54:14 Johannes Berg wrote:
> On Fri, 2008-06-06 at 23:06 +0200, Ivo Couckuyt wrote:
> > Sorry for the late reply, i just thought i install kernel 2.6.25 r4 and
> > try again.
> >
> > It is somewhat better and worse, when modprobing p54usb i got a small
> > hang/hickup accompanied with the following error in dmesg
> > ehci_hcd 0000:00:02.2: HC died; cleaning up
> > [...]
>
> Sorry, no idea. Christian?
Not yet... but card is on the way, so maybe in the future. :)

I googled for "HC died; cleaning up" and yes, there "are" other people with 
the same issue... But noone had a solutions other than use ndiswrapper.

So, i took a look at the driver... it ships with a really old firmware 2.4.6.0 
So, I know that there are atleast some (mini)PCI Cards that have big problems 
with anything newer than 2.4.x.y, maybe there are broken USB-Parts too...

Ivo, can you please try the older firmware? You can find a copy @
(http://daemonizer.de/prism54/prism54-fw/ scroll down to USB).

If this doesn't work? could you please about ndiswrapper?

Regards,
	Christian
