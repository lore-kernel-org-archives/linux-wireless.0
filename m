Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37818 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754602AbeFNJMp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 05:12:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Protect ath10k_htt_rx_ring_free with rx_ring.lock
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1528387897-6781-1-git-send-email-greearb@candelatech.com>
References: <1528387897-6781-1-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Message-Id: <20180614091245.7C8266055D@smtp.codeaurora.org> (sfid-20180614_111250_198226_69F28BAF)
Date: Thu, 14 Jun 2018 09:12:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:

> From: Ben Greear <greearb@candelatech.com>
> 
> While debugging driver crashes related to a buggy firmware
> crashing under load, I noticed that ath10k_htt_rx_ring_free
> could be called without being under lock.  I'm not sure if this
> is the root cause of the crash or not, but it seems prudent to
> protect it.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Failed to apply, please use ath.git master branch as the baseline. Also
document the tested hardware and firmware versions in the commit log.

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches

error: patch failed: drivers/net/wireless/ath/ath10k/htt_rx.c:282
error: drivers/net/wireless/ath/ath10k/htt_rx.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10453105/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
