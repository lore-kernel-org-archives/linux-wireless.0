Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7442 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881AbcGHOHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 10:07:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix possible wrong rx_busy time reporting in QCA4019
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1467371245-5426-1-git-send-email-vthiagar@qti.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Message-ID: <daa5435e9e124d1e8f2e0d05b1543c18@euamsexm01a.eu.qualcomm.com> (sfid-20160708_160731_680409_AB57F45B)
Date: Fri, 8 Jul 2016 16:06:25 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> wrote:
> As hw cycle counters in QCA4019 wraparound independantly in QCA4019
> it is possible cycle counter and rx clear counter would wraparound
> at the same time. Current logic assumes only one of the counters
> would wraparound at anytime. Fix this by moving 'else' part to
> another 'if'.
> 
> Fixes: 8e100354a98 ("ath10k: fix cycle counter wraparound handling for QCA4019")
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

c11e99396d0f ath10k: fix possible wrong rx_busy time reporting in QCA4019

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9209723/

