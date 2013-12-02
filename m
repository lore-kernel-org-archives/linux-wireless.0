Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53610 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3LBHnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 02:43:00 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH] ath10k: fix multi BSSID with WPA on FW 10.1
References: <1385737763-10481-1-git-send-email-bartosz.markowski@tieto.com>
Date: Mon, 2 Dec 2013 09:42:55 +0200
In-Reply-To: <1385737763-10481-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Fri, 29 Nov 2013 16:09:23 +0100")
Message-ID: <87wqjnbsw0.fsf@kamboji.qca.qualcomm.com> (sfid-20131202_084304_912763_393D4B1A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> From: Michal Kazior <michal.kazior@tieto.com>
>
> FW 10.1 seems to require the default key index to
> be updated to point to group key after it is
> installed. Otherwise Txed frames are corrupted.
>
> Tested-by: Tomasz Skapski <tomasz.skapski@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I see few checkpatch warnings:

drivers/net/wireless/ath/ath10k/mac.c:2721: ERROR: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/mac.c:2722: ERROR: code indent should use tabs where possible
drivers/net/wireless/ath/ath10k/mac.c:2723: ERROR: code indent should use tabs where possible

-- 
Kalle Valo
