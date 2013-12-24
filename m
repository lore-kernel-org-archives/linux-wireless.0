Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:50383 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3LXXbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 18:31:51 -0500
Received: by mail-ee0-f44.google.com with SMTP id b57so3127907eek.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Dec 2013 15:31:49 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Scott S <scotta1265@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: will rtl8192su driver work for 64-bit kernel 3.2.0-23-generic?
Date: Wed, 25 Dec 2013 00:31:42 +0100
Message-ID: <106771444.37oG374YIb@debian64> (sfid-20131225_003217_118259_EF9F5356)
In-Reply-To: <CAGqmZoTrBnxcemEjc67o==K_TZCm8D+yr3BjqiaTKfXsRugaPA@mail.gmail.com>
References: <CAGqmZoR8rXm5hNp6pMfESMM7a31aVpNeeGwxMY1Ng4sUXsJ_tg@mail.gmail.com> <3015747.JIT0jyjz1q@debian64> <CAGqmZoTrBnxcemEjc67o==K_TZCm8D+yr3BjqiaTKfXsRugaPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, December 24, 2013 03:59:19 PM Scott S wrote:
> >>> I'm looking for a better driver for a Rosewill RNX-N180UBE USB wifi on
> >>> 64-bit Linux Mint 13 (Ubuntu 12LTS Kernel 3.2.0-23) the Ubuntu driver
> >>> is junk+10.
> 
> -------------------------------------
> 
> >in what way is it junk? Is it crashing/misbehaving, does it lack important
> >features, is the wifi connection unstable, or is something else bothering
> >you?
> 
> Well, let's see, this is a new USB antenna, but this is what I've
> noticed so far:
> 
> Sometimes I get a "black screen of death" crash when watching hi-speed
> streaming videos on Amazon or NFL.com, or during shut-down , but not
> sure, because sometimes the message is Kernel BUG: xxxxxxx whatever
> and  ---cut here------ and other messages... but I only get those
> messages when this one is plugged in. (I have 2 other USB antennas
> that I can't get to work well either, but of the 3, this one works the
> best) hahaha :)
> 
> Here's some of the other problems I've noticed:
> 
> It doesn't turn-off from the applet (the signal strength indicator
> always stays on, then it's locked up. Won't do jack on/off)
> Suspend wake-up problems.
> Crashes when uplugged, but not all the time...
> 
> System won't completely shutdown when plugged in or after unplugged,
> and more error messages.
> 
> (I've had some success using using CTRL+ALT+PrnScr REISUB sometimes
> for a complete shutdown.)
> 
> Other than that, it works great! No, really. Better than my other 2.
> When it works, it's fast.

This is great data (do you think you could capture a few of those error
messages?). Since all this sounds like "just" driver problems... and they
can be fixed (or are already fixed, after all 3.2 was releases almost two
years ago). Do you know the module name of the driver you are currently
using? ("lsmod" can tell you that, it should be something like r8712u, 
rtl8190n or rtl8192su). Maybe there is already an intermediate solution.

> > Oh, you can help with the rtl8192su-mac80211 driver rewrite. This would
> > certainly make a difference :-D
> 
> I really wish I could. I love Linux.
> 
> But wait a minute, if it's doomed anyway. :/
Wait a minute ;-).  r92su is "doomed" since it doesn't provide any major
improvements over r8712u (apart from the cfg80211 interface). However,
the rtl8192su-mac80211 driver is not doomed, but it needs "free hands".

> Thanks for the response and Merry Christmas Happy New Year
Thank you, the same to you.
 
Christian
