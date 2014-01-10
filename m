Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:51998 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaAJKEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 05:04:34 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: add set_bitrate_mask callback
References: <1389168513-5606-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Fri, 10 Jan 2014 12:04:11 +0200
In-Reply-To: <1389168513-5606-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Wed, 8 Jan 2014 09:08:33 +0100")
Message-ID: <87k3e89mqs.fsf@kamboji.qca.qualcomm.com> (sfid-20140110_110438_315161_5CF89F9D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Add set_bitrate_mask callback. Currently
> ath10k HW is limited to handle only single
> fixed rate setting or limit number of used
> spatial streams.
>
> Example:
> iw wlanX set bitrates legacy-5 ht-mcs-5 vht-mcs-5 2:9
> will setup VHT, nss=2, mcs=9
>
> iw wlanX set bitrates legacy-5 18 ht-mcs-5 vht-mcs-5
> will setup legacy, 18Mbps
>
> iw wlanX set bitrates legacy-5 ht-mcs-5 3 vht-mcs-5
> will setup HT, nss=1, mcs=3
>
> iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9
> will setup nss=1
>
> iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9 2:0-9
> will setup nss=2
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo
