Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36925 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968441Ab0B0Otg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 09:49:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA errors
Date: Sat, 27 Feb 2010 15:49:27 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <201002262120.37438.mb@bu3sch.de> <alpine.LFD.2.00.1002261231320.4513@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002261231320.4513@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002271549.28154.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 February 2010 21:33:08 Linus Torvalds wrote:
> 
> On Fri, 26 Feb 2010, Michael Buesch wrote:
> > 
> > I'd rather appreciate that somebody who owns such a device and can reproduce the bug
> > would do some _real_ debugging on the issue instead.
> 
> I have the hardware, I can reproduce the bug 100% of the time.
> 
> So send me a patch. I'll try it.

Well, unfortunately it is not as easy as sending a patch and testing it.
If that was the case, the bug would've never hit you. Some serious very basic
debugging work has to be done first. What we did for now basically was just
poking around in the dark. What we need to do is find out what triggers
the behavior. One thing that we know is that there are identical cards that
work fine in one machine and fail in another. So it is kind of machine dependent.
The first thing I would try is to start disabling features in the BIOS.
You can't really do this remotely via email, so I think there needs to be done
some work by somebody who knows what he does _and_ is able to reproduce the bug.

-- 
Greetings, Michael.
