Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57738 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbeC2Izo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:55:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: refactor ath10k_pci_dump_memory() in preparation
 for QCA9984 support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522054714-31492-1-git-send-email-kvalo@codeaurora.org>
References: <1522054714-31492-1-git-send-email-kvalo@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180329085544.26983602BA@smtp.codeaurora.org> (sfid-20180329_105547_602767_94381AB9)
Date: Thu, 29 Mar 2018 08:55:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> wrote:

> As QCA9984 needs two region types refactor the code to make it easier add the
> new types. No functional changes.
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

10c228843081 ath10k: refactor ath10k_pci_dump_memory() in preparation for QCA9984 support
219cc084c670 ath10k: add memory dump support QCA9984

-- 
https://patchwork.kernel.org/patch/10307431/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
