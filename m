Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34638 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbeC2JC2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 05:02:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Advertize beacon_int_min_gcd
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1520428356-2762-1-git-send-email-akolli@codeaurora.org>
References: <1520428356-2762-1-git-send-email-akolli@codeaurora.org>
To: akolli@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Message-Id: <20180329090228.878C960C55@smtp.codeaurora.org> (sfid-20180329_110233_067075_C5974735)
Date: Thu, 29 Mar 2018 09:02:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@codeaurora.org wrote:

> This patch fixes regression caused by 0c317a02ca98
> ("cfg80211: support virtual interfaces with different beacon intervals"),
> with this change cfg80211 expects the driver to advertize
> 'beacon_int_min_gcd' to support different beacon intervals in multivap
> scenario. This support is added for, QCA988X/QCA99X0/QCA9984/QCA4019.
> 
> Verifed AP + mesh bring up on QCA9984 with beacon interval 100msec and
> 1000msec respectively.
> Frimware: firmware-5.bin_10.4-3.5.3-00053
> 
> Fixes: 0c317a02ca98 ("cfg80211: support virtual interfaces with different beacon intervals")
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

8ebee73b574a ath10k: advertize beacon_int_min_gcd

-- 
https://patchwork.kernel.org/patch/10263995/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
