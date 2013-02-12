Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50357 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab3BLKE5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 05:04:57 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [BUG] Beacon loss event every second
References: <5118F682.8000502@neratec.com>
	<1360592857.8738.30.camel@jlt4.sipsolutions.net>
	<51190341.40806@neratec.com>
Date: Tue, 12 Feb 2013 12:04:54 +0200
In-Reply-To: <51190341.40806@neratec.com> (Wojciech Dubowik's message of "Mon,
	11 Feb 2013 15:42:09 +0100")
Message-ID: <87bobpc0ft.fsf@purkki.adurom.net> (sfid-20130212_110500_764218_308CB431)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik <Wojciech.Dubowik@neratec.com> writes:

> I have connection without sending any data.
>
> I have seen that  ieee80211_sta_rx_notify doesn't count beacons
> so the time is not resetted. What was the reason not to count them
> for beacon loss work? Something connected with PS?
>
> Anyway I should get the event every
>
> IEEE80211_BEACON_LOSS_COUNT * bcn period
>
> which in my case should be 7 * 30 ms = 210 ms and not 1 second.
>
> I will keep on digging.

What driver are you using?

-- 
Kalle Valo
