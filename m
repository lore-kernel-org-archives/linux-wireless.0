Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbYAYRsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 12:48:11 -0500
Subject: Re: Linux 2.6.24-rc7
From: Dan Williams <dcbw@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	 <1201264166.12870.16.camel@johannes.berg>
	 <alpine.LFD.1.00.0801250753240.14161@hp.linux-foundation.org>
	 <200801251723.58891.mb@bu3sch.de>
	 <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org>
	 <1201282027.3422.15.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 12:42:52 -0500
Message-Id: <1201282972.3422.19.camel@localhost.localdomain> (sfid-20080125_174821_158490_44B67213)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-01-25 at 09:38 -0800, Linus Torvalds wrote:
> 
> On Fri, 25 Jan 2008, Dan Williams wrote:
> > 
> > Does Intel need to make iwlwifi and ipw2x00 work reliably on platforms
> > other than x86?  Or don't they?
> 
> Why should they? 
> 
> If somebody else takes over maintenance, because Intel does a bad job, 
> that's fine.
> 
> If somebody else sends in patches and they get accepted "around" Intel, 
> that's obviously also fine.
> 
> But complaining about a vendor who does a good job technically, for 
> non-technical reasons, I really don't see that as being fine.
> 
> Is it even physically *possible* to use that Intel wireless chipset with 
> anything but x86 CPU's (not just that, but actually _Intel_ x86 CPU's)? 
> And would it make any sense what-so-ever even if it was?

Yeah, 3945 and 4965 cards are mini PCI-E these days.  And there are
ipw2100, ipw2200, and ipw2915 mini PCI cards that you could stick in
embedded systems and such.  Though of course everyone doing embedded
stuff uses either Atheros or PrismII still, certainly not ipw/iwl.

This discussion occurred on May 18 - May 21, 2007 on linux-wireless with
the thread heading "[PATCH]  Add iwlwifi wireless drivers [part 2/2]".

Dan

> And yes, portability is a great thing, but quite frankly, so is good 
> hardware. I personally can't really blame Intel engineers for not caring 
> about irrelevant hardware. 
> 
> We should make technical decisions on _technical_ grounds, not some 
> perceived "this is how the world should work" grounds.
> 
> 		Linus

