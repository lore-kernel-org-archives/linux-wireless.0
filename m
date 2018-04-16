Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37662 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753479AbeDPNmj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:42:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] ath10k: support MAC address randomization in scan
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
References: <1522379640-6442-3-git-send-email-cjhuang@codeaurora.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180416134238.CC2E260A00@smtp.codeaurora.org> (sfid-20180416_154242_516347_D4FC8E49)
Date: Mon, 16 Apr 2018 13:42:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Carl Huang <cjhuang@codeaurora.org> wrote:

> The ath10k reports the random_mac_addr capability to upper layer
> based on the service bit firmware reported. Driver sets the
> spoofed flag in scan_ctrl_flag to firmware if upper layer has
> enabled this feature in scan request.
> 
> Test with QCA6174 hw3.0 and firmware-6.bin_WLAN.RM.4.4.1-00102-QCARMSWP-1,
> but QCA9377 is also affected.
> 
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This added a new checkpatch warning:

drivers/net/wireless/ath/ath10k/wmi-ops.h:123: Alignment should match open parenthesis

I fixed it in the pending branch.

-- 
https://patchwork.kernel.org/patch/10316769/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
