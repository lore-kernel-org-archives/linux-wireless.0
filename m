Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:51243 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab3EPSue (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 14:50:34 -0400
Date: Thu, 16 May 2013 20:50:30 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k_htc: Target is unresponsive
Message-ID: <20130516185030.GB16833@zenon.in.qult.net> (sfid-20130516_205043_917742_0C5AF1D8)
References: <20130515134258.GA9033@zenon.in.qult.net>
 <5194DEB3.2060407@rempel-privat.de>
 <20130516172030.GD21850@zenon.in.qult.net>
 <51951B90.70909@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51951B90.70909@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 16, 2013 at 07:46:56PM +0200, thus spake Oleksij Rempel:
> Am 16.05.2013 19:20, schrieb Ignacy Gawedzki:
> >TP-Link TL-WN722NC, exactly as the one on the wiki.
> 
> That is interesting. I have got today TL-WN722N, but i still can't
> reproduce this issue.

Are you sure that not any subsystem ups the interface before you have any
chance to warm reboot?  Or that you don't have a hub that cuts power to
devices on warm reboot?

> >I tried to solder the TX pin, but it's really too tiny.  I don't have an iron
> >so small as to be able to do it, sorry.  I would really love to have an UART
> >connection, but that's just beyond my abilities.  BTW, it would really be
> >great to have a way to send debug message up the USB link, just as with
> >carl9170.
> 
> That make no sense. Debug message i need, are from boot loader.
> There is no way, that boot loader can send messages over usb. Or if
> firmwre will crash, it wont send any thing too.

I understand.

> So what do we have:
> - TL-WN722N is working. Or your model is different, or it is broken one.

I happen to have 8 of them, bought at different times and all exhibit the
problem.

> - Did you checked the cable?

I usually plug the device directly to the USB port, but I also happen to use
the cradle (supplied with the WN722NC version) that has a cable, when I need
two wireless interfaces on the RPi (both of them don't fit at once directly on
the ports).

> - usb host controller?

I'll try on yet another one and will tell you the results.

> - other options?

Hmmm... :/

-- 
-= Best Viewed Using [INLINE] =-
