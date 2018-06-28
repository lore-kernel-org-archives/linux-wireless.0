Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933896AbeF1Jih (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:38:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix tlv 5ghz channel missing issue
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523345994-28800-2-git-send-email-zhichen@codeaurora.org>
References: <1523345994-28800-2-git-send-email-zhichen@codeaurora.org>
To: zhichen@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        kvalo@qca.qualcomm.com, Zhi Chen <zhichen@codeaurora.org>
Message-Id: <20180628093836.A2AF860791@smtp.codeaurora.org> (sfid-20180628_113841_027100_F441A6C3)
Date: Thu, 28 Jun 2018 09:38:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zhichen@codeaurora.org wrote:

> The 5ghz channel parameters of TLV target wasn't passed to host, it caused
> host can only use lower channels from 36 to 64.
> 
> Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

98dc04ba60b9 ath10k: fix tlv 5ghz channel missing issue

-- 
https://patchwork.kernel.org/patch/10332449/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
