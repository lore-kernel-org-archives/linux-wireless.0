Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22396 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbbIZSQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2015 14:16:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 4.3 RESEND] ath10k: fix DMA related firmware crashes on multiple devices
References: <1442219607-12383-1-git-send-email-nbd@openwrt.org>
Date: Sat, 26 Sep 2015 21:16:21 +0300
In-Reply-To: <1442219607-12383-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Mon, 14 Sep 2015 10:33:27 +0200")
Message-ID: <87wpvdcah6.fsf@kamboji.qca.qualcomm.com> (sfid-20150926_201636_423831_88C3C756)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> Some platforms really don't like DMA bursts of 256 bytes, and this
> causes the firmware to crash when sending beacons.
> Also, changing this based on the firmware version does not seem to make
> much sense, so use 128 bytes for all versions.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied to ath-current branch in ath.git.

-- 
Kalle Valo
