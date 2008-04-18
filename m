Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.241]:36555 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbYDROvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 10:51:02 -0400
Received: by hs-out-0708.google.com with SMTP id 4so381697hsl.5
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2008 07:51:01 -0700 (PDT)
Message-ID: <40f31dec0804180751y3c4e0a9bj509324ae712081f3@mail.gmail.com> (sfid-20080418_155108_252490_DAA5D9BB)
Date: Fri, 18 Apr 2008 17:51:01 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: ath5k phy0: noise floor calibration timeout
Cc: "Pierre Frenkiel" <pierre.frenkiel@apc.univ-paris7.fr>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1208526988.9388.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <Pine.LNX.4.64.0804181435480.16108@apcnb28.in2p3.fr>
	 <1208526988.9388.12.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/4/18, Dan Williams <dcbw@redhat.com>:
> On Fri, 2008-04-18 at 14:51 +0200, Pierre Frenkiel wrote:
>  > hi,
>  > I have a 3-com PCCARD, with the AR5413 chipset
>  > I installed 2 days ago compat-wireless-2.6.tar.bz2, on Ubuntu Gutsy,
>  > and everything seemed to work.
>  > I just had in the log 2 or 3 messages:
>  >
>  >     ath5k phy0: noise floor calibration timeout
>  >
>  > but yesterday, when rebooting, I got a huge number of such messages(more
>  > than 100 in the log file), with also
>  >
>  >     ath5k phy0: ath5k_chan_set: unable to reset channel
>  >     ath0: failed to set freq to 2422 MHz for scan
>  >     ath0: failed to restore operational channel after scan
>
>
> I also get this all the time with a 5006E, and ath5k takes quite a lot
>  (30%) of CPU most of the time.  Haven't tried to track it down yet.
>  Anyone have ideas about the root cause of the problem?
>
>
>  Dan
>
>  > and the boot froze. I then removed my PCCARD,
>  > and after poweroff/poweron, I could boot normally.
>  >
>  > It seems to be fixed now, as I have no more this problem after
>  > re-inserting the card.
>  > But as I did nothing, I would like to know what might happen:
>  > If this happened once, there is no reason why this would not happen an
>  > other time.
>  >
>  > Pierre
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

It seems that sometimes noise floor calibration takes longer than
usual. I'll check it out and come up with a patch asap ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
