Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:48907 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab1JCOVk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 10:21:40 -0400
Message-ID: <4E89C4F1.2090708@neratec.com> (sfid-20111003_162143_752442_173A2392)
Date: Mon, 03 Oct 2011 16:21:37 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, rodrigue@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [RFC 3/6] ath9k: initial radar pulse detection for DFS
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>	<1317637758-11907-4-git-send-email-zefir.kurtisi@neratec.com>	<CAJ-VmonP5V2dL8aYiMRrkNcQR19kKAy2PCWHSkxb1biyJS7pow@mail.gmail.com>	<4E89A941.8060208@neratec.com> <CAJ-Vmomx8eSBTEZ3A_vnw8GaWh2dO3CFD-MZ6zzBDmWKZx7=xw@mail.gmail.com>
In-Reply-To: <CAJ-Vmomx8eSBTEZ3A_vnw8GaWh2dO3CFD-MZ6zzBDmWKZx7=xw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2011 02:43 PM, Adrian Chadd wrote:
> On 3 October 2011 20:23, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> 
>> There might be one, but I left it out (for now) for the sake of simplicity.
>>
>> I anyhow doubt it has a practical relevance, since the pulse width is reported with usec granularity and therefore a scaling factor of 1/811 vs. 1/800 has no impact on the re-scaled value for widths up to 50 usecs.
> 
> I just remember this was a sticking point when porting the fusion code
> to FreeBSD.
> Without that particular fix, some of the radar patterns didn't
> actually match reliably.
> 
> It's possible it doesn't matter as much for your classification code.
> I'm just bringing it up to be complete. :)
> 
> 
> 
> Adrian

Thanks!

Most probably it'll end being added to the lengthy TODO list.


Zefir
