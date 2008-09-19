Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39927 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYISXxZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 19:53:25 -0400
Date: Fri, 19 Sep 2008 16:53:05 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Noonan <steven@uplinklabs.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Ingo Molnar <mingo@elte.hu>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
Message-ID: <20080919235305.GD11665@tesla> (sfid-20080920_015330_191040_99437B59)
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com> <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com> <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com> <20080919030125.GG7408@tesla> <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com> <20080919142801.GA5816@senthil-lnx.users.atheros.com> <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net> <20080919175824.GA5626@senthil-lnx.users.atheros.com> <20080919182322.GB7027@tesla> <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 04:31:20PM -0700, Steven Noonan wrote:
> 
> On Fri, 19 Sep 2008, Luis R. Rodriguez wrote:
> > Thanks for the patch Senthil. He is on Linus' v2.6.27-rc, you are on
> > wireless-testing so I've ported it (no changes, it just applies cleanly
> > now). This is also untested by me:
> 
> I'm seeing the same latency issue I reported originally with the latest
> -tip kernel and WITHOUT irqpoll.

Damn it.

> Apparently there's something else to this...

Steven,

Can you reproduce this? If so can you tell us how? If you can reproduce
can you try to test this with wireless-testing as well? That is still
based on 2.6.26-rc6 but its just has all the new wireless development
stuff queued up for 2.6.28 so far. Everything else is the same.

  Luis
