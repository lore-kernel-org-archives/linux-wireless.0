Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48226 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754927AbeFNPOQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 11:14:16 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: snoc: use module_platform_driver() macro
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180611193540.190255-1-briannorris@chromium.org>
References: <20180611193540.190255-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20180614151415.A33036022C@smtp.codeaurora.org> (sfid-20180614_171433_366134_FA8D9CE9)
Date: Thu, 14 Jun 2018 15:14:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:

> ath10k_snoc_init()/ath10k_snoc_exit() don't add much value;
> module_platform_driver() can remove the boilerplate.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

0644fef97451 ath10k: snoc: use module_platform_driver() macro

-- 
https://patchwork.kernel.org/patch/10458705/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
