Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4969 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbZBFSiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 13:38:21 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Hugh Dickins <hugh@veritas.com>, linville@tuxdriver.com
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>, maximlevitsky@gmail.com
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
Date: Fri, 6 Feb 2009 13:37:49 -0500
Message-Id: <20090206183443.M95991@bobcopeland.com> (sfid-20090206_193825_829439_A62B3F83)
In-Reply-To: <Pine.LNX.4.64.0902061305530.15787@blonde.anvils>
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils> <1231426017.922.2.camel@maxim-laptop> <Pine.LNX.4.64.0901081603410.8411@blonde.anvils> <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com> <Pine.LNX.4.64.0901081740350.19523@blonde.anvils> <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com> <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com> <Pine.LNX.4.64.0901091400290.925@blonde.anvils> <20090110164705.GB10865@hash.localnet> <20090110201547.GA11261@hash.localnet> <Pine.LNX.4.64.0901131509080.9571@blonde.anvils> <20090113154204.M52697@bobcopeland.com> <Pine.LNX.4.64.0902061305530.15787@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 6 Feb 2009 13:12:34 +0000 (GMT), Hugh Dickins wrote
> Hi Bob,
> 
> On Tue, 13 Jan 2009, Bob Copeland wrote:
> > On Tue, 13 Jan 2009 15:35:29 +0000 (GMT), Hugh Dickins wrote
> > > But I haven't seen any allocation failure for several days.
> > > I didn't get any while trying to simplify the reproduction,
> > 
> > I'll go ahead and push this upstream then today or tomorrow; let me 
> > know if you run into any problems with more testing.
> 
> Just a prod: I've not seen your fix go into the 2.6.29-rc tree yet.

Good point, it is queued for 2.6.30.  John, would there be any problem
with including a8e3cd514, "ath5k: fix bf->skb==NULL panic in 
ath5k_tasklet_rx" for 2.6.29?

-- 
Bob Copeland %% www.bobcopeland.com


