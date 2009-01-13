Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49269 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZAMQmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 11:42:05 -0500
Received: from [172.20.25.81]([172.20.25.81]) (2845 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1LMmJN-0002VJC@megami.veritas.com>
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 08:40:17 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
Date: Tue, 13 Jan 2009 16:40:21 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
To: Bob Copeland <me@bobcopeland.com>
cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>, maximlevitsky@gmail.com,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
In-Reply-To: <20090113154204.M52697@bobcopeland.com>
Message-ID: <Pine.LNX.4.64.0901131636190.23199@blonde.anvils> (sfid-20090113_174215_236381_ABF58AA2)
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils>
 <1231426017.922.2.camel@maxim-laptop> <Pine.LNX.4.64.0901081603410.8411@blonde.anvils>
 <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com>
 <Pine.LNX.4.64.0901081740350.19523@blonde.anvils>
 <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com>
 <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com>
 <Pine.LNX.4.64.0901091400290.925@blonde.anvils> <20090110164705.GB10865@hash.localnet>
 <20090110201547.GA11261@hash.localnet> <Pine.LNX.4.64.0901131509080.9571@blonde.anvils>
 <20090113154204.M52697@bobcopeland.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 13 Jan 2009, Bob Copeland wrote:
> On Tue, 13 Jan 2009 15:35:29 +0000 (GMT), Hugh Dickins wrote
> 
> I'll go ahead and push this upstream then today or tomorrow;

Great, thanks - should include a Cc: stable@kernel.org I think.

> let me know if you run into any problems with more testing.

Sure, will do.

> > > Changes-licensed-under: 3-Clause-BSD
> > 
> > Hmm, I haven't noticed anyone doing that before: hope you're not
> > starting a trend!  I think you'll find (Documentation/SubmittingPatches)
> > that your Signed-off-by agrees to the Developer's Certificate of Origin
> > 1.1, which would put your patch under the same open source licence(s) as
> > drivers/net/wireless/ath5k/base.c already contains - that's the usual
> > case.
> 
> I agree with all of the above, but the SFLC suggests we do it anyway.
> 
> http://kerneltrap.org/Linux/Wireless_Project_Suggests_Changes-licensed-under_Tag

Interesting, thanks a lot for the pointer.
I agree very much with Steve and Krzysztof.

I'd be inclined to think that adding such a line in some patches
would only tend towards making those which omit such a line more
questionable for use under the BSD licence i.e. would weaken the
BSD position rather than strengthening it as intended - though
the Signed-off-by should override even that tendency.

But it's certainly not an issue for my attention!

Hugh
