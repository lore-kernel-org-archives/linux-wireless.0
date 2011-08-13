Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49117 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1HMUeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 16:34:24 -0400
Received: by fxh19 with SMTP id 19so2919137fxh.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 13:34:23 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: carl9170 does not like all frequencies
Date: Sat, 13 Aug 2011 22:34:16 +0200
Cc: linux-wireless@vger.kernel.org
References: <j26l8a$ea9$1@dough.gmane.org>
In-Reply-To: <j26l8a$ea9$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201108132234.16886.chunkeey@googlemail.com> (sfid-20110813_223429_811700_89E7B2CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 August 2011 22:02:18 Bernd Schubert wrote:
> I bought a new usb wifi device with 2 antennas to get a better
> connection to my router.
So, you are saying that there was something wrong with the old
stick as well, right!?

> From point of few of connection strength that worked out very well, from
> point of view of connection stability that is total disaster so far.
Sure, you are affected by constant "loud" noise on the frequency/band.
The hardware is unable to finish the noise floor calibration and therefore
gives up.

> With Ubuntus 2.6.38-something it connects and then entirely fails after
> sending a few bytes. So I checked git log and noticed carl9170 is being
> used in recent kernels and connection issues have been fixed in 3.1-git.
what commits are you talking about?

> > [ 1058.936551] cfg80211: Calling CRDA to update world regulatory domain
> > [ 1058.945510] cfg80211: World regulatory domain updated:
> > [ 1058.945519] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> > [ 1058.945529] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> > [ 1058.945538] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> > [ 1058.945547] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> > [ 1058.945555] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> > [ 1058.945563] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> > [ 1058.945604] cfg80211: Calling CRDA for country: 97
> > [ 1061.373997] ieee80211 phy1: channel change: 2417 -> 2422 failed (2).
> > [ 1061.682115] ieee80211 phy1: channel change: -1 -> 2422 failed (2).
> > [ 1061.682132] usb 10-1.2: restart device (7)
> > [ 1062.096523] cfg80211: Calling CRDA to update world regulatory domain
> > [ 1062.105469] cfg80211: World regulatory domain updated:
> 
> 
> Any idea what is going on here? Do I need a crda tool? Or is something
> else failing?
Yes, you need crda, if you haven't installed it already.

> Update: While writing this up and after I plugged in my zd1211rw device,
> eventually also my tp-link carl9170 device connected a few minutes
> later. Do I always have to wait for 20 minutes to get a connection now?
That's odd. TP-Link does not sell any AR9170 anymore, in fact they dropped it
more than a year ago and replaced the line-up with AR7010+AR9287? so where
did you get this obsolete device?

Regards,
	Chr
