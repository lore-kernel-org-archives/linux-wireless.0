Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40095 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbbJNLN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:13:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [RESEND] ath9k: Fix NF CCA limits for AR9287 and AR9227
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	nbd@openwrt.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Message-Id: <20151014111356.197E9141C67@smtp.codeaurora.org> (sfid-20151014_131400_079057_AA681BDC)
Date: Wed, 14 Oct 2015 11:13:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


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

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
