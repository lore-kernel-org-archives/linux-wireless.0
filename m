Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52296 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754108AbeBGOOx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 09:14:53 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: Fix get channel default noise floor
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1516976454-8883-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1516976454-8883-1-git-send-email-Wojciech.Dubowik@neratec.com>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Message-Id: <20180207141453.7ED2A60767@smtp.codeaurora.org> (sfid-20180207_151504_921600_9E35BB4C)
Date: Wed,  7 Feb 2018 14:14:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik <Wojciech.Dubowik@neratec.com> wrote:

> Commit 8da58553cc63 ("ath9k: Use calibrated noise floor value
> when available") introduced regression in ath9k_hw_getchan_noise
> where per chain nominal noise floor has been taken instead default
> for channel.
> Revert to original default channel noise floor.
> 
> Fixes: 8da58553cc63 ("ath9k: Use calibrated noise floor value when available")
> Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-current branch of ath.git, thanks.

b9607de6cf22 ath9k: Fix get channel default noise floor

-- 
https://patchwork.kernel.org/patch/10186025/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
