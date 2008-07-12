Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55286 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYGLPdG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2008 11:33:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: rt2x00 is still experimental?
Date: Sat, 12 Jul 2008 17:31:57 +0200
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <1215811139.30975.10.camel@dv> <20080712104659.jsizw0ndw44cw4kc-cebfxv@webmail.spamcop.net> <200807121713.54123.IvDoorn@gmail.com>
In-Reply-To: <200807121713.54123.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807121731.57208.mb@bu3sch.de> (sfid-20080712_173311_158023_B9BDC419)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 12 July 2008 17:13:54 Ivo van Doorn wrote:
> On Saturday 12 July 2008, Pavel Roskin wrote:
> > Quoting Ivo van Doorn <ivdoorn@gmail.com>:
> > 
> > > Hi,
> > >
> > >> Can we please have rt2x00 drivers considered stable in Linux 2.6.27?
> > >
> > > No.
> > >
> > >> My experience running rt73 day by day with WPA on a very crowded network
> > >> shows that it's a pretty reliable driver already.
> > >
> > > Perhaps managed mode, but not adhoc mode, beaconing is still broken.
> > > In addition the leds are broken as well, and hardware encryption   
> > > isn't in either.
> > 
> > I see.  It must be a perception thing.  Things I hack on seem  
> > unstable, but things that just work seem stable :)
> 
> Well it is at least good to know managed mode is working well for you. :)
> 
> > Thank you for the status.  Good luck with fixing the remaining problems!
> 
> Thanks,

I think the EXPERIMENTAL flag is just meaningless.
You cannot run a kernel without it, as so many required and working
subsystems and drivers depend on it.
So I decided to drop EXPERIMENTAL for b43, as It Works (tm) for most users.
Sure, there are a lot of corners that need fixing, but fixing them all
up before removing EXPERIMENTAL would most likely never happen.

So we removed EXPERIMENTAL from the driver when the driver worked
for most users in STA mode. IMO that improves the overall situation,
as it's one less EXPERIMENTAL dependency, that isn't really one.

-- 
Greetings Michael.
