Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5375 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbbFPKKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 06:10:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: enable VHT for IBSS
References: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 16 Jun 2015 13:10:35 +0300
In-Reply-To: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Wed, 10 Jun 2015 07:14:44 +0200")
Message-ID: <87mw007ylg.fsf@kamboji.qca.qualcomm.com> (sfid-20150616_121055_755638_522EBA72)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Enable VHT support for IBSS, while mac80211/cfg80211 and
> wpa_supplicant already support this.
>
> In my test env, ath10k 2x2 I get:
> (udp) ath10k-1 >>>> ath10k-2 (server) -  speed: 419 Mbits/sec
> (tcp) ath10k-1 >>>> ath10k-2 (server) -  speed: 404 Mbits/sec
>
> During tests I used wpa_supplicant (current version), which
> already support IBSS VHT, and choose highest available BW.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
