Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51382 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab0HBUwK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 16:52:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 13:52:10 -0700
Date: Mon, 2 Aug 2010 13:52:05 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jan Friedrich <jft@dev2day.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [Patch] ath9k: fix erased ieee80211_rx_status.mactime
Message-ID: <20100802205205.GG8920@tux>
References: <4C57278E.1030601@dev2day.de>
 <20100802202137.GC8920@tux>
 <4C572C18.6070003@dev2day.de>
 <20100802203843.GD8920@tux>
 <4C572F31.3050809@dev2day.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C572F31.3050809@dev2day.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 02, 2010 at 01:48:49PM -0700, Jan Friedrich wrote:
> > Think? Does the patch actually fix something or do you think it fixes
> > something? Next time please include all these details on your patch
> > commit log mesage so its easy to understand the reasoning behind
> > the patch.
> 
> It fixes the problem I described. Now the mactime is set correctly and
> the IBSS merge is done only once and by the correct station. I noticed
> no negative side effect and tested it with 10+ stations in IBSS mode.
> 
> Sorry for the inconvenience. Next time I will provide more information.

no problem, can you resubmit but add all these details to the commit log?
ALso, is this a stable kernel fix, that is, does this fix need to be
propagated to the stable kernels, 2.6.35, 2.6.34, 2.6.33, 2.6.32?

  Luis
