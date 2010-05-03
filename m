Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ip84.de ([212.122.42.5]:38468 "EHLO bart.ip84.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab0ECQyJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 12:54:09 -0400
From: "rain_maker@root-forum.org" <rain_maker@root-forum.org>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: remove USB-ID 148f:2573 from rt2500usb driver
Date: Mon, 3 May 2010 18:53:56 +0200
References: <201005031624.45409.rain_maker@root-forum.org> <201005031720.36288.rain_maker@root-forum.org> <20100503154745.GB24781@tuxdriver.com>
In-Reply-To: <20100503154745.GB24781@tuxdriver.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201005031853.56995.rain_maker@root-forum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Monday 03 May 2010 17:47:46 schrieben Sie:
>
> http://osdir.com/ml/linux-wireless/2009-07/msg00267.html
>
> This seems to be such an example?

Yeah, I also found that one before, but the message about missing firmware 
(which is the most common user's error with rt73usb) and lack of feedback 
from the person opening the thread if rt2500usb got  the device working made 
it "inconclusive" to me.

But maybe this is the main reason one finds so many threads about problems 
with this device id and rt73usb being the correct driver.

If it works out of the box (no matter which driver), nobody starts a thread, 
if it doesn't work, in most cases it's missing firmware and if rt2500usb 
works instead of rt73usb, you can't miss that as it does not need 
installation of extra firmware.

I CCed Ivo instead of first sending him this mail only personally, because 
although I knew he would be the most likely person to know if my idea was 
good or bad (which was exactly what happened), I expected that if there 
really are a few devices with 148f:2573 needing rt2500usb instead of rt73usb, 
the more likely somebody else actually will know about such a (rare) 
exception.

Maybe that was not too clever, sorry for this rather useless thread.

Greetings,

Axel K
