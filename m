Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753816AbeC1PrF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 11:47:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2] ath10k: Add tx ack signal support for management frames
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519883841-4117-1-git-send-email-vnaralas@codeaurora.org>
References: <1519883841-4117-1-git-send-email-vnaralas@codeaurora.org>
To: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Message-Id: <20180328154704.E8E2F60BFA@smtp.codeaurora.org> (sfid-20180328_174709_253731_058A6815)
Date: Wed, 28 Mar 2018 15:47:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Venkateswara Naralasetty <vnaralas@codeaurora.org> wrote:

> This patch add support to get RSSI from acknowledgment
> frames for transmitted management frames.
> 
> hardware_used: QCA4019, QCA9984.
> firmware version: 10.4-3.5.3-00052.
> 
> Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This adds new ath10k-check warnings:

drivers/net/wireless/ath/ath10k/htt_rx.c:2733:52: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath/ath10k/htt_rx.c:2730: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/htt_rx.c:2733: line over 90 characters
drivers/net/wireless/ath/ath10k/htt_rx.c:2734: line over 90 characters

-- 
https://patchwork.kernel.org/patch/10250443/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
