Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:41065 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab0IBSMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 14:12:55 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Sep 2010 11:12:50 -0700
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Timo Juhani Lindfors <timo.lindfors@iki.fi>,
	Michael Trimarchi <michael@panicking.kicks-ass.org>
CC: Peter Korsgaard <jacmet@sunsite.dk>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Date: Thu, 2 Sep 2010 11:12:54 -0700
Subject: RE: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
Message-ID: <35B17FE5076C7040809188FBE7913F983F234795E4@SC1EXMB-MBCL.global.atheros.com>
References: <1283381473-20415-1-git-send-email-vmehta@atheros.com>
	<87tym8vdio.fsf@macbook.be.48ers.dk>
	<4C7F74A4.1080706@panicking.kicks-ass.org> <84hbi82zwm.fsf@sauna.l.org>
In-Reply-To: <84hbi82zwm.fsf@sauna.l.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Timo,
   Has this issue been already addressed with the version of the driver on which it was found? If yes, then we should try to get the fix(es) incorporated in ath6kl after a review so that we do not have the same problem with AR6003.

Regards,
Vipin 

> -----Original Message-----
> From: Timo Juhani Lindfors [mailto:timo.lindfors@iki.fi] 
> Sent: Thursday, September 02, 2010 3:39 AM
> To: Michael Trimarchi
> Cc: Peter Korsgaard; Vipin Mehta; 
> linux-wireless@vger.kernel.org; Luis Rodriguez; 
> devel@linuxdriverproject.org
> Subject: Re: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
> 
> Michael Trimarchi <michael@panicking.kicks-ass.org> writes:
> > Looking at the code I think that is basically the same.
> 
> Does it then also suffer from the bug where a non-root user 
> can sabotage your network connectivity by periodically 
> disabling power_mode MAX_PERF_POWER? I'm not a kernel hacker 
> but I could not see anything checking for root or 
> CAP_NET_ADMIN in the proposed driver.
> 
> The bug report for the git.openmoko.org branch is at
> http://docs.openmoko.org/trac/ticket/2321
> 