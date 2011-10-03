Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:35267 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692Ab1JCMXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 08:23:32 -0400
Message-ID: <4E89A941.8060208@neratec.com> (sfid-20111003_142335_616859_8420DCF7)
Date: Mon, 03 Oct 2011 14:23:29 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, rodrigue@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [RFC 3/6] ath9k: initial radar pulse detection for DFS
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>	<1317637758-11907-4-git-send-email-zefir.kurtisi@neratec.com> <CAJ-VmonP5V2dL8aYiMRrkNcQR19kKAy2PCWHSkxb1biyJS7pow@mail.gmail.com>
In-Reply-To: <CAJ-VmonP5V2dL8aYiMRrkNcQR19kKAy2PCWHSkxb1biyJS7pow@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2011 01:57 PM, Adrian Chadd wrote:
> Just out of curiousity, is there any "fast clock" on or off with the AR93xx ?
> 
> (That's one of the gotchas I came across when porting DFS code to
> FreeBSD for the AR9160/AR9280.)
> 
> Thanks,
> 
> 
> Adrian

There might be one, but I left it out (for now) for the sake of simplicity.

I anyhow doubt it has a practical relevance, since the pulse width is reported with usec granularity and therefore a scaling factor of 1/811 vs. 1/800 has no impact on the re-scaled value for widths up to 50 usecs.


Zefir
