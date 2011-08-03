Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm9-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.249]:35794
	"HELO nm9-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754948Ab1HCMir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 08:38:47 -0400
Date: Wed, 3 Aug 2011 08:33:31 -0400
From: jason@monsterjam.org
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: drops with compat-wireless-3.0-2 and ath9k_htc
Message-ID: <20110803123331.GA9168@monsterjam.org> (sfid-20110803_143853_391012_221DF399)
References: <20110802001821.GA29352@monsterjam.org>
 <CAD2nsn0WqpHsJAODziyO1SFUT4Pm-fkp=zvcdyckJgfDeAMdcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD2nsn0WqpHsJAODziyO1SFUT4Pm-fkp=zvcdyckJgfDeAMdcQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 02, 2011 at 11:00:43AM +0530, Mohammed Shafi wrote:
> On Tue, Aug 2, 2011 at 5:48 AM,  <jason@monsterjam.org> wrote:
> > hey folks, running ?2.6.38.8-32.fc15.i686 ?with a
> > Bus 001 Device 003: ID 0cf3:7015 Atheros Communications, Inc.
> > adapter, and I keep seeing hangs on my workstation.
> 
> we will try to recreate it here.
> when are you getting this issue(AP mode or station mode). any other
> information will be helpful.
not sure what you mean by AP or station.. my dlink wireless is acting as a router (not a wireless bridge if thats what you 
mean)
> also does it happens with wireless-testing ?
> 

actually i think the problem may be gone.. I uninstalled network manager and did some fedora updates.. now im running 
 2.6.38.8-35.fc15.i686 with the stock kernel ath9k drivers (not the 3.0 vers)..
ill let yall know if the problem happens again.

regards,
Jason

> >
> > here is the output from the latest time it happened..
> >
> > [32322.166396] ath: Chip reset failed
> > [32322.166404] ath: Unable to reset channel (2452 Mhz) reset status -22
> > [32322.167608] ath: Unable to set channel
> > [32322.167631] wlan2: deauthenticating from 00:24:01:43:24:b4 by local choice (reason=3)
> > [32322.276851] ath: Chip reset failed
> > [32322.276856] ath: Unable to reset hardware; reset status -22 (freq 2452 MHz)
> > [32322.379231] cfg80211: Calling CRDA to update world regulatory domain
> > [32322.394452] ath: Failed to wakeup in 500us
> > [32322.408122] ath: Failed to wakeup in 500us
> > [32322.418226] ath: Failed to wakeup in 500us
> > [32322.648187] usb 1-3: ath9k_htc: USB layer deinitialized
> > [32322.651879] cfg80211: World regulatory domain updated:
> > [32322.651896] cfg80211: ? ? (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> > [32322.651900] cfg80211: ? ? (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> > [32322.651904] cfg80211: ? ? (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> > [32322.651907] cfg80211: ? ? (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> > [32322.651910] cfg80211: ? ? (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> > [32322.651913] cfg80211: ? ? (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> >
> > the wireless router is a ?netgear wireless N router thats running dd-wrt.
> >
> > it seems if I unplug the usb adapter and reinsert it, the computer will recover just fine.
> >
> >
> > thanks/regards,
> > Jason
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at ?http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> -- 
> shafi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

