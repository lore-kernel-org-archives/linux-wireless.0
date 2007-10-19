Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2390 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760039AbXJSOjD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 10:39:03 -0400
Date: Fri, 19 Oct 2007 10:22:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH #3] b43: Fix sparse warnings.
Message-ID: <20071019142205.GA2920@tuxdriver.com> (sfid-20071019_153907_120062_56AD367D)
References: <200710171834.03495.mb@bu3sch.de> <20071018195322.GD8510@tuxdriver.com> <200710191547.13533.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200710191547.13533.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 19, 2007 at 03:47:13PM +0200, Michael Buesch wrote:
> On Thursday 18 October 2007 21:53:22 John W. Linville wrote:
> > On Wed, Oct 17, 2007 at 06:34:03PM +0200, Michael Buesch wrote:
> > > The remaining warning in phy.c will be fixed later.
> > > 
> > > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > > 
> > > ---
> > > 
> > > John, this is the third time I submit this.
> > > Is something wrong with this patch or did you simply forget to apply it?
> > 
> > Where are you looking?  It is in Linus' tree.
> > 
> > 	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1a09404a2338163f181d170c7abdc2242b6c6f03
> > 
> > John
> 
> Uhm, it still applies to wireless-2.6#everything.

I imagine that it won't when that gets rebased, probably after
2.6.24-rc1. :-)

Seriously, either I must have neglected to add it to everything and
merged-upstream.  I'll look into it.  The important thing is that
Linus has it.

John
-- 
John W. Linville
linville@tuxdriver.com
