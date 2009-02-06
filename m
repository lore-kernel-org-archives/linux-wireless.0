Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59821 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbZBFNNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 08:13:47 -0500
Received: from [172.20.28.128]([172.20.28.128]) (2182 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1LVQVt-0000GcC@megami.veritas.com>
	for <linux-wireless@vger.kernel.org>; Fri, 6 Feb 2009 05:12:57 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
Date: Fri, 6 Feb 2009 13:12:34 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
To: Bob Copeland <me@bobcopeland.com>
cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>, maximlevitsky@gmail.com
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
In-Reply-To: <20090113154204.M52697@bobcopeland.com>
Message-ID: <Pine.LNX.4.64.0902061305530.15787@blonde.anvils> (sfid-20090206_141351_800841_8D7E1637)
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

Hi Bob,

On Tue, 13 Jan 2009, Bob Copeland wrote:
> On Tue, 13 Jan 2009 15:35:29 +0000 (GMT), Hugh Dickins wrote
> > But I haven't seen any allocation failure for several days.
> > I didn't get any while trying to simplify the reproduction,
> 
> I'll go ahead and push this upstream then today or tomorrow; let me 
> know if you run into any problems with more testing.

Just a prod: I've not seen your fix go into the 2.6.29-rc tree yet.

I confess that not even once since then have I seen the page allocation
failure which led to the BUG you've fixed: though most of my testing
has been on 2.6.29-rc kernels, so my guess would be that something
else has changed to make a failure there less likely.

But I do still carry your patch, and would be reassured to see it in.

Thanks,
Hugh
