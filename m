Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:38889 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2ECU1r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 16:27:47 -0400
Subject: Re: [PATCH 2/2] tcp: cleanup tcp_try_coalesce
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
	alexander.duyck@gmail.com, alexander.h.duyck@intel.com,
	netdev@vger.kernel.org, edumazet@google.com,
	jeffrey.t.kirsher@intel.com, linux-wireless@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20120503170727.GM9285@tuxdriver.com>
References: <1336017985.12425.9.camel@edumazet-glaptop>
	 <4FA21087.1080801@gmail.com> <1336022373.12425.24.camel@edumazet-glaptop>
	 <20120503.012502.44731688706812861.davem@davemloft.net>
	 <20120503151418.GJ9285@tuxdriver.com>
	 <1336058659.27487.80.camel@wwguy-huron>
	 <20120503170727.GM9285@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 May 2012 13:21:12 -0700
Message-ID: <1336076472.27487.82.camel@wwguy-huron> (sfid-20120503_222752_365807_FE438227)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Thu, 2012-05-03 at 13:07 -0400, John W. Linville wrote:
> On Thu, May 03, 2012 at 08:24:19AM -0700, Guy, Wey-Yi wrote:
> > Hi John,
> > 
> > On Thu, 2012-05-03 at 11:14 -0400, John W. Linville wrote:
> > > On Thu, May 03, 2012 at 01:25:02AM -0400, David Miller wrote:
> > > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > > Date: Thu, 03 May 2012 07:19:33 +0200
> > > > 
> > > > > My last patch against iwlwifi is still waiting to make its way into
> > > > > official tree.
> > > > > 
> > > > > http://www.spinics.net/lists/netdev/msg192629.html
> > > > 
> > > > John, please rectify this situation.
> > > > 
> > > > The Intel Wireless folks said they would test it, but that was more
> > > > than a month ago.
> > > > 
> > > > It's not acceptable to let bug fixes rot for that long, I don't care
> > > > what their special internal testing procedure is.
> > > > 
> > > > If they give you further pushback, please just ignore them and apply
> > > > Eric's fix directly.
> > > > 
> > > > Thank you.
> > > 
> > > I imagine that this somehow got lost in the shuffle during the
> > > merge window.  That doesn't excuse it, of course.
> > > 
> > > It has waited long enough already, so I'll just go ahead and take it.
> > > 
> > it is my mistake to lost this patch during the iwlwifi re-factor work,
> > the patch is no longer apply and I ask Eric to rebase the patch.
> > 
> > Sorry again for the mistake
> 
> Well, it seems like a fix needed for 3.4.  And, the patch applies there.
> 
> It does cause some merge breakage in wireless-testing (and presumably
> in linux-next).  I'll attach the commit diff for the wireless-testing
> merge fixup I did, for review and/or as a peace offering to sfr... :-)
> 
> Please take a look at the result in wireless-testing and let me know
> if it is broken...thanks!
> 
Looks good to me, thanks very much for helping this.

Wey

> 


