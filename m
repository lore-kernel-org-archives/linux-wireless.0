Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43553 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZBFSpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 13:45:53 -0500
Date: Fri, 6 Feb 2009 13:44:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Hugh Dickins <hugh@veritas.com>, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	maximlevitsky@gmail.com
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
Message-ID: <20090206184445.GB7526@tuxdriver.com> (sfid-20090206_194556_475020_C3D14427)
References: <Pine.LNX.4.64.0901081740350.19523@blonde.anvils> <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com> <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com> <Pine.LNX.4.64.0901091400290.925@blonde.anvils> <20090110164705.GB10865@hash.localnet> <20090110201547.GA11261@hash.localnet> <Pine.LNX.4.64.0901131509080.9571@blonde.anvils> <20090113154204.M52697@bobcopeland.com> <Pine.LNX.4.64.0902061305530.15787@blonde.anvils> <20090206183443.M95991@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090206183443.M95991@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 06, 2009 at 01:37:49PM -0500, Bob Copeland wrote:
> On Fri, 6 Feb 2009 13:12:34 +0000 (GMT), Hugh Dickins wrote
> > Hi Bob,
> > 
> > On Tue, 13 Jan 2009, Bob Copeland wrote:
> > > On Tue, 13 Jan 2009 15:35:29 +0000 (GMT), Hugh Dickins wrote
> > > > But I haven't seen any allocation failure for several days.
> > > > I didn't get any while trying to simplify the reproduction,
> > > 
> > > I'll go ahead and push this upstream then today or tomorrow; let me 
> > > know if you run into any problems with more testing.
> > 
> > Just a prod: I've not seen your fix go into the 2.6.29-rc tree yet.
> 
> Good point, it is queued for 2.6.30.  John, would there be any problem
> with including a8e3cd514, "ath5k: fix bf->skb==NULL panic in 
> ath5k_tasklet_rx" for 2.6.29?

Hmmm...well it is a little big, but I guess it is OK.  Do you have
an example of the stack trace?  Or a link to a bugzilla or somesuch
would be even better...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
