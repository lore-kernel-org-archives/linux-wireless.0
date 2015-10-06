Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42858 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbbJFOQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 10:16:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	nbd@openwrt.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND] ath9k: Fix NF CCA limits for AR9287 and AR9227
References: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
Date: Tue, 06 Oct 2015 17:16:14 +0300
In-Reply-To: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
	(Martin Blumenstingl's message of "Wed, 22 Jul 2015 10:42:43 +0200")
Message-ID: <87mvvw13rl.fsf@kamboji.qca.qualcomm.com> (sfid-20151006_161625_466712_6185B767)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> The FreeBSD driver [0] uses the same 2G values as for the AR9280 chips.
> Using the same values in ath9k results in much better throughput for me.
>
> Before this patch I had a huge amount of packet loss (sometimes up to
> 40%) and the max transfer speed was somewhere around 5Mbit/s. With this
> patch applied I have zero packet loss and ten times the throughput.
> My device uses a AR9227 which is the PCI variant of the AR9287.
>
> [0] http://bxr.su/FreeBSD/sys/dev/ath/ath_hal/ar9002/ar9287.h
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

So what should I do with this patch? Is this good to apply?

Discussion here:

https://patchwork.kernel.org/patch/6841051/

-- 
Kalle Valo
