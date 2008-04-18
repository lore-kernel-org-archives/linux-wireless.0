Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYDRN7s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 09:59:48 -0400
Subject: Re: ath5k phy0: noise floor calibration timeout
From: Dan Williams <dcbw@redhat.com>
To: Pierre Frenkiel <pierre.frenkiel@apc.univ-paris7.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0804181435480.16108@apcnb28.in2p3.fr>
References: <Pine.LNX.4.64.0804181435480.16108@apcnb28.in2p3.fr>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 09:56:28 -0400
Message-Id: <1208526988.9388.12.camel@localhost.localdomain> (sfid-20080418_145952_132166_5304CD4E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-04-18 at 14:51 +0200, Pierre Frenkiel wrote:
> hi,
> I have a 3-com PCCARD, with the AR5413 chipset
> I installed 2 days ago compat-wireless-2.6.tar.bz2, on Ubuntu Gutsy,
> and everything seemed to work.
> I just had in the log 2 or 3 messages:
> 
>     ath5k phy0: noise floor calibration timeout
> 
> but yesterday, when rebooting, I got a huge number of such messages(more
> than 100 in the log file), with also
> 
>     ath5k phy0: ath5k_chan_set: unable to reset channel
>     ath0: failed to set freq to 2422 MHz for scan
>     ath0: failed to restore operational channel after scan

I also get this all the time with a 5006E, and ath5k takes quite a lot
(30%) of CPU most of the time.  Haven't tried to track it down yet.
Anyone have ideas about the root cause of the problem?

Dan

> and the boot froze. I then removed my PCCARD,
> and after poweroff/poweron, I could boot normally.
> 
> It seems to be fixed now, as I have no more this problem after
> re-inserting the card. 
> But as I did nothing, I would like to know what might happen: 
> If this happened once, there is no reason why this would not happen an
> other time.
> 
> Pierre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

