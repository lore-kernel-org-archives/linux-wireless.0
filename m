Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752332AbeDSPvV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 11:51:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: build ce layer in ath10k core module
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1521615247-3715-1-git-send-email-govinds@codeaurora.org>
References: <1521615247-3715-1-git-send-email-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Message-Id: <20180419155121.5D7AE60F6E@smtp.codeaurora.org> (sfid-20180419_175125_571349_EC64E8D3)
Date: Thu, 19 Apr 2018 15:51:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> CE layer is shared between pci and snoc target and results
> in duplicate object inclusion if both modules are compiled
> together statically and undefined KBUILD_MODNAME if
> compiled as module.
> 
> Fix this by building ce layer in ath10k core module by
> adding ce object inclusion with ATH10K_CE boolean CONFIG.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

a0aedd6e0b57 ath10k: build ce layer in ath10k core module

-- 
https://patchwork.kernel.org/patch/10298657/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
