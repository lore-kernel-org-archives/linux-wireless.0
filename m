Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50460 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbeDSPsb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 11:48:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv3] ath10k: Add tx ack signal support for management frames
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522316915-27518-1-git-send-email-vnaralas@codeaurora.org>
References: <1522316915-27518-1-git-send-email-vnaralas@codeaurora.org>
To: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Message-Id: <20180419154831.38FC96071A@smtp.codeaurora.org> (sfid-20180419_174859_972237_912A6EC7)
Date: Thu, 19 Apr 2018 15:48:31 +0000 (UTC)
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

Patch applied to ath-next branch of ath.git, thanks.

235b9c427661 ath10k: Add tx ack signal support for management frames

-- 
https://patchwork.kernel.org/patch/10314823/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
