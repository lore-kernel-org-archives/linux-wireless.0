Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4579 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaB0Qim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:38:42 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: set the mactime of ieee80211_rx_status
References: <1392197866-1261-1-git-send-email-yeohchunyeow@gmail.com>
Date: Thu, 27 Feb 2014 18:38:36 +0200
In-Reply-To: <1392197866-1261-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Wed, 12 Feb 2014 17:37:46 +0800")
Message-ID: <87ppm8ecj7.fsf@kamboji.qca.qualcomm.com> (sfid-20140227_173845_437345_ACF32CBD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> Retrieve the mactime of ieee80211_rx_status based on received
> data frame. The value is obtained from the htt_rx_indication_ppdu
> structure and only available in 32-bit.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Thanks, applied.

If we learn better way to do this with full TSF, let's do that in a
followup patch.

-- 
Kalle Valo
