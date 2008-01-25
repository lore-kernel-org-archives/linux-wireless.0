Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2761 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684AbYAYWDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 17:03:16 -0500
Date: Fri, 25 Jan 2008 16:46:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080125214626.GG14687@tuxdriver.com> (sfid-20080125_220320_240100_6BEA274D)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801251941.25310.mb@bu3sch.de> <200801251311.45392.inaky@linux.intel.com> <200801252221.07558.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200801252221.07558.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2008 at 10:21:07PM +0100, Michael Buesch wrote:
> On Friday 25 January 2008 22:11:44 Inaky Perez-Gonzalez wrote:
> > On Friday 25 January 2008, Michael Buesch wrote:
> > > On Friday 25 January 2008 19:34:46 Linus Torvalds wrote:
> > > > My attitude is: CPU's that do unaligned accesses right are the *good* 
> > > > CPU's. We should encourage them, and put the onus of being crap on the 
> > > > ones that are crap, rather than penalizing the ones that aren't.
> > > 
> > > I absolutely agree. But as this can get fixed with _no_ performance loss
> > > at all inside of the firmware (and who if not intel can change stuff
> > > in their firmware?), I think this warning is in fact valid.
> > 
> > Well, you forgot the point that maybe it is not that simple to get such
> > a seemingly simple change into the firmware for a long list of reasons.
> 
> The reasons being?

Firmware certification is expensive.

Plus it is a bit unfair to ask for firmware changes just because the
vendor is actually engaged with us.  If this were Broadcom or Zydas
firmware we would have little recourse other than to accept it or
fix it in the driver or stack.

John
-- 
John W. Linville
linville@tuxdriver.com
