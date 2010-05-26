Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slowhand.arndnet.de ([88.198.19.76]:55349 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754081Ab0EZRaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:30:55 -0400
Message-ID: <4BFD555C.4060205@nets.rwth-aachen.de>
Date: Wed, 26 May 2010 19:07:40 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>
Subject: Re: regulatory problems with ath5k
References: <4BFD04A4.4000403@nets.rwth-aachen.de>
In-Reply-To: <4BFD04A4.4000403@nets.rwth-aachen.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

FWI: I believe this whole regulatory framework is pretty broken in 2.6.34
If I associate with a 802.11g accesspoint with one NIC , I'm not allowed
to use 802.11a on my other NIC at all.

[   23.352168] wlan0: associated
[   23.355993] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   23.375106] cfg80211: Calling CRDA for country: DE
[   23.412542] cfg80211: Current regulatory domain updated by AP to: DE
[   23.431728]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   23.454319]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 1800 mBm)

# iw reg get
country 98:
    (2402 - 2482 @ 40), (N/A, 18)

???

Best regards,
Arnd

