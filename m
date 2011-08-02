Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61897 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1HBFao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 01:30:44 -0400
Received: by wwe5 with SMTP id 5so6347272wwe.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 22:30:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110802001821.GA29352@monsterjam.org>
References: <20110802001821.GA29352@monsterjam.org>
Date: Tue, 2 Aug 2011 11:00:43 +0530
Message-ID: <CAD2nsn0WqpHsJAODziyO1SFUT4Pm-fkp=zvcdyckJgfDeAMdcQ@mail.gmail.com> (sfid-20110802_073050_067502_46939E8F)
Subject: Re: drops with compat-wireless-3.0-2 and ath9k_htc
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: jason@monsterjam.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 2, 2011 at 5:48 AM,  <jason@monsterjam.org> wrote:
> hey folks, running  2.6.38.8-32.fc15.i686  with a
> Bus 001 Device 003: ID 0cf3:7015 Atheros Communications, Inc.
> adapter, and I keep seeing hangs on my workstation.

we will try to recreate it here.
when are you getting this issue(AP mode or station mode). any other
information will be helpful.
also does it happens with wireless-testing ?

>
> here is the output from the latest time it happened..
>
> [32322.166396] ath: Chip reset failed
> [32322.166404] ath: Unable to reset channel (2452 Mhz) reset status -22
> [32322.167608] ath: Unable to set channel
> [32322.167631] wlan2: deauthenticating from 00:24:01:43:24:b4 by local choice (reason=3)
> [32322.276851] ath: Chip reset failed
> [32322.276856] ath: Unable to reset hardware; reset status -22 (freq 2452 MHz)
> [32322.379231] cfg80211: Calling CRDA to update world regulatory domain
> [32322.394452] ath: Failed to wakeup in 500us
> [32322.408122] ath: Failed to wakeup in 500us
> [32322.418226] ath: Failed to wakeup in 500us
> [32322.648187] usb 1-3: ath9k_htc: USB layer deinitialized
> [32322.651879] cfg80211: World regulatory domain updated:
> [32322.651896] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [32322.651900] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [32322.651904] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [32322.651907] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [32322.651910] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [32322.651913] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>
> the wireless router is a  netgear wireless N router thats running dd-wrt.
>
> it seems if I unplug the usb adapter and reinsert it, the computer will recover just fine.
>
>
> thanks/regards,
> Jason
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
