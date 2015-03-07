Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11533 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbbCGH4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 02:56:48 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix TxBF VHT capabilities for 2+ RF-chain devices
References: <1424945482-9765-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 7 Mar 2015 09:56:39 +0200
In-Reply-To: <1424945482-9765-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 26 Feb 2015 11:11:22 +0100")
Message-ID: <871tl11brc.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_085650_994354_F27402E4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Firmware doesn't report a complete and
> ready-to-use vht cap. Instead the driver is
> supposed to fill in the missing bits related to
> number of chains.
>
> This effectively increases Compressed Steering
> Number and Number of Sounding Dimensions in
> AssocReq frames for devices with more than one RF
> chain and should improve TxBF performance.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
