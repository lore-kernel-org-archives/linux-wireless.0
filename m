Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48996 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbYG2MGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 08:06:10 -0400
Date: Tue, 29 Jul 2008 08:04:42 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Subject: Re: 2.6.27-rc1: zd1211rw association fails
Message-ID: <20080729120442.GE9378@mit.edu> (sfid-20080729_140613_559021_F64450C1)
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <200807291049.47342.alistair@devzero.co.uk> <1217326195.10489.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217326195.10489.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 12:09:55PM +0200, Johannes Berg wrote:
> This is about the 100 millionth time this is reported. Please try the
> patch I just posted.

Yeah, it's really too bad -rc1 got released just before you were able
to post the fix to this, since if there were 100 million people who
were trying out kernels starting with -git7 that use wireless, there
will probably be 200 million people trying out -rc1.  :-)

Thanks for finding and fixing it, though.  I stopped trying out
kernels after -git6 since I was travelling at OSCON, and not having
wireless was a show-stopper for me....

						- Ted
