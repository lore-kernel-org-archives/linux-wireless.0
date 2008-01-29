Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:17062 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752335AbYA2TMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 14:12:21 -0500
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: David Miller <davem@davemloft.net>
Subject: Re: Linux 2.6.24-rc7
Date: Tue, 29 Jan 2008 11:07:10 -0800
Cc: mb@bu3sch.de, torvalds@linux-foundation.org,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <200801251311.45392.inaky@linux.intel.com> <200801251328.35985.inaky@linux.intel.com> <20080126.054223.118097210.davem@davemloft.net>
In-Reply-To: <20080126.054223.118097210.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200801291107.11221.inaky@linux.intel.com> (sfid-20080129_191229_484106_5C273CF7)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 January 2008, David Miller wrote:
> From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
> Date: Fri, 25 Jan 2008 13:28:35 -0800
> 
> > For example: want to ship new firmware, drivers *and* full validation and
> > certification for a product that is already completed just to satisfy a 
> > fraction of a market which is not part of the designed target?
> > 
> > Do you know how much money that costs?
> 
> I'm glad you guys are the only one's with access to the firmware
> source, thus enduring that you can constantly come up with reasons
> like this in order to not have to fix the problem.

At the risk of falling into your game, let me reiterate what I said 
above, as you don't seem to have  taken it into acount:

   want to ship new firmware, drivers *and* full validation and
   certification for a product that is already completed just to satisfy a 
   fraction of a market which is not part of the designed target?

   Do you know how much money that costs?

Maybe there is somewhere someone willing to pony up all the the money 
needed to get all that started and done, but we are not in that position,
so in those cases, we need to do some kind of software arrangement.

But even still, cref to some of Linus's message in this thread: that doesn't 
mean  people would use it. Workaround broken stuff because it is there already
and ask for the vendor to fix things.

We listen, participate, release code and we try hard to get the stuff right 
in current releases when doable, in future as much as possible. It doesn't 
help anyone when you just go about ripping us senseless.

> You know that if the source were available, the community would have
> fixed the bug ages ago.
>
> But the situation is entirely in Intel's control which is surely
> exactly the way they like it.

Do you have the (open) source to any wireless card firmware? I'd be 
curious to know, because I (personally) don't know how can you do an 
open source firmware for a software defined radio without the FCC 
denying you a license. No license, no product. No product, no need to
even have this discussion... :)
