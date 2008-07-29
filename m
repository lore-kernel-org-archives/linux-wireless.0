Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3287 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYG3Enj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 00:43:39 -0400
Date: Tue, 29 Jul 2008 13:52:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Theodore Tso <tytso@MIT.EDU>,
	Alistair John Strachan <alistair@devzero.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Subject: Re: 2.6.27-rc1: zd1211rw association fails
Message-ID: <20080729175206.GB4923@tuxdriver.com> (sfid-20080730_064344_152244_5E6DE80B)
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <200807291049.47342.alistair@devzero.co.uk> <1217326195.10489.10.camel@johannes.berg> <20080729120442.GE9378@mit.edu> <1217333359.10489.38.camel@johannes.berg> <1217333706.10489.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217333706.10489.40.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 02:15:06PM +0200, Johannes Berg wrote:
> 
> > > Yeah, it's really too bad -rc1 got released just before you were able
> > > to post the fix to this, since if there were 100 million people who
> > > were trying out kernels starting with -git7 that use wireless, there
> > > will probably be 200 million people trying out -rc1.  :-)
> > > 
> > > Thanks for finding and fixing it, though.  I stopped trying out
> > > kernels after -git6 since I was travelling at OSCON, and not having
> > > wireless was a show-stopper for me....
> > 
> > If everybody's going to decide now to hit on _me_, I'll point out that
> > davem's MQ TX changes broke it
> 
> Of course that's not strictly true, it had been broken forever, it just
> happened to never show up before. And I mean forever, the original
> devicescape code that got in was already broken.

FWIW, I think the MQ stuff didn't spend much (or any) time in -next...

-- 
John W. Linville
linville@tuxdriver.com
