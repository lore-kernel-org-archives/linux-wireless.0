Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0IGVCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 17:02:51 -0400
To: Steve deRosier <steve@cozybit.com>
Subject: Re: =?UTF-8?Q?libertas=5Ftf?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Sep 2010 23:02:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTimgvEShOKnA3TTf0_3p2ghP2OL8ngKPBgpkf+zf@mail.gmail.com>
References: <1282764076.3667.12.camel@jlt3.sipsolutions.net> <AANLkTikc0-FbeRHm-0rxrWCGgaxa7svCsQmqpAD-87cq@mail.gmail.com> <5144f966da86d4ab0984bc15bdd5fcab@localhost> <AANLkTimgvEShOKnA3TTf0_3p2ghP2OL8ngKPBgpkf+zf@mail.gmail.com>
Message-ID: <d09bb244b842cf15a1513899d19bd39d@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 7 Sep 2010 13:52:47 -0700, Steve deRosier <steve@cozybit.com>
wrote:
> I've got it working on 2.6.34-rc5-wl, branched off commit
> ~8425ee8329f33 sometimes near the end of April 2010.  I've
> significantly reworked some MAC addr stuff, including forcing the
> module to request the MAC addr from the hardware and using that to set
> the addr before the calls to setup mac80211.

Ah, ok, but that's the thing I was worried about ... if you're now giving
it the MAC address before setting up the mac80211 stuff, you should be fine
(and we can remove the workaround from mac80211, yay)

> I'm now working on getting it all up to head, so patches should be
> coming soon.  Actually, on that note, how would you prefer I get them
> to you?  We're talking about an entire new module, libertas_tf_sdio,
> and lots of patches to the existing libertas_tf modules.  Something
> like 40+ patches.  Would you prefer a patchset posted, or me to squash
> a bunch into fewer but larger patches, or would you prefer to pull
> from my git tree?

Sounds like a lot of stuff... John will have to answer that. I think
posting it piecemeal as much as possible would probably be preferable.

johannes
