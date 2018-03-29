Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39610 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeC2JJx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 05:09:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix vdev stats for 10.4 firmware
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1521227710-3155-1-git-send-email-rmanohar@codeaurora.org>
References: <1521227710-3155-1-git-send-email-rmanohar@codeaurora.org>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Message-Id: <20180329090953.1D75E60BFA@smtp.codeaurora.org> (sfid-20180329_110957_144308_ABF7EA70)
Date: Thu, 29 Mar 2018 09:09:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> wrote:

> Currently vdev stats displayed in fw_stats are applicable
> only for TLV based firmware and fix it for 10.4 firmware
> as of now. The vdev stats in 10.4 firmware is split into two
> parts (vdev_stats, vdev_stats_extended). The actual stats
> are captured only in extended vdev stats. In order to enable
> vdev stats, appropriate feature bit will be set on extended
> resource config. As FTM related counters are available only on
> newer 10.4 based firmware, these counters will be displayed
> only on valid data.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

1b3fdb50f881 ath10k: fix vdev stats for 10.4 firmware

-- 
https://patchwork.kernel.org/patch/10289879/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
