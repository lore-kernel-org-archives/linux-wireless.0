Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbeGaJVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:21:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath10k: fix parenthesis alignment
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <153297700266.4874.12439168003972242663.stgit@potku.adurom.net>
References: <153297700266.4874.12439168003972242663.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180731074223.115D660714@smtp.codeaurora.org> (sfid-20180731_094226_634939_BC8EC1D7)
Date: Tue, 31 Jul 2018 07:42:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> wrote:

> These were recently introduced and found by checkpatch:
> 
> drivers/net/wireless/ath/ath10k/mac.c:6118: Alignment should match open parenthesis
> drivers/net/wireless/ath/ath10k/mac.c:6121: Alignment should match open parenthesis
> drivers/net/wireless/ath/ath10k/mac.c:6124: Alignment should match open parenthesis
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ebfac1d0c166 ath10k: fix parenthesis alignment

-- 
https://patchwork.kernel.org/patch/10549583/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
