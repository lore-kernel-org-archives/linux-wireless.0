Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33176 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759065AbXGYBfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2007 21:35:12 -0400
Message-ID: <46A6A8CD.9080806@garzik.org>
Date: Tue, 24 Jul 2007 21:35:09 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Stephen.Clark@seclark.us
CC: James Ketrenos <jketreno@linux.intel.com>,
	Axj <axjslack@bluebottle.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] Request for help...
References: <1185289332.46a61474a444c@mail.bluebottle.com>	<20070724161226.GA24344@tuxdriver.com>	<46A64503.1080003@seclark.us>	<20070724203035.GG24344@tuxdriver.com>	<46A66B63.6030006@garzik.org> <46A6A447.2080903@linux.intel.com> <46A69359.4030201@garzik.org> <46A69998.7020108@seclark.us>
In-Reply-To: <46A69998.7020108@seclark.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Clark wrote:
> I find it really sad that a hardware vendor that is willing to write and 
> develope drivers for Linux for their hardware aren't helped more by "the 
> community"

It's hard to be more helpful without (a) explaining the problems with 
the current situation and suggesting corrections, or (b) doing it all 
myself.


> or is the "the community" only interested in hacking drivers where
> the manufacturer give no or minimal support?

The more people working on drivers, the wider the workload is spread, 
which is a good thing.

The caveat being you cannot just throw any old crap into the kernel, 
just because you are a Big Hardware Vendor.  Linux thrives precisely 
because of the system of engineering review and Internet-scale testing 
that we have set up.

We have an engineering process that has proven itself over the past 10+ 
years.  You don't just chuck that out the window because someone doesn't 
want to follow the process.  Making exceptions for Big Vendors who can't 
grok the rules is not how Linux became successful.

These processes all have carefully considered engineering rationale 
behind them.  The obvious engineering breakdowns occur when you avoid 
the standard process...  the process that has been delivering stable 
hardware support to you and other Linux users.


> I appreciate Intel's support for being open and purposely bought a 
> laptop that had an Intel graphics chipset and an Intel wireless card.

Intel gets five stars in the areas of open source CPU, platform, and 
graphics support.  Intel graphics is really going to kick ass (not that 
it doesn't already), and Keith Packard (old-school X11 hacker) is 
leading the charge.  And Intel networking definitely gets applause for 
doing open source networking as well.

But we just don't shove any old vendor driver into the kernel.  Not when 
we have to maintain these drivers for a decade, often after the vendor 
themselves end-of-life's the chip.

	Jeff


