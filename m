Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60322 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755376AbeFNOq4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 10:46:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: support for multicast rate control
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1525743291-4306-1-git-send-email-pradeepc@codeaurora.org>
References: <1525743291-4306-1-git-send-email-pradeepc@codeaurora.org>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Message-Id: <20180614144655.B82C960795@smtp.codeaurora.org> (sfid-20180614_164704_020791_3F3A754A)
Date: Thu, 14 Jun 2018 14:46:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org> wrote:

> Issues wmi command to firmwre when multicast rate change is received
> with the new BSS_CHANGED_MCAST_RATE flag.
> Also fixes the incorrect fixed_rate setting for CCK rates which got
> introduced with addition of ath10k_rates_rev2 enum.
> 
> Tested on QCA9984 with firmware ver 10.4-3.6-00104
> 
> Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

ath10k-check found some whitespace issues:

drivers/net/wireless/ath/ath10k/mac.c:6110: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/mac.c:6113: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/mac.c:6116: Alignment should match open parenthesis

I fixed those in the pending branch.

-- 
https://patchwork.kernel.org/patch/10385043/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
