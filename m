Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49674 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755158AbeFNPQr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 11:16:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] ath10k: snoc: use correct bus-specific pointer in RX retry
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180611210946.241341-1-briannorris@chromium.org>
References: <20180611210946.241341-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20180614151647.26CB36022C@smtp.codeaurora.org> (sfid-20180614_171702_038284_760126CE)
Date: Thu, 14 Jun 2018 15:16:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:

> We're 'ath10k_snoc', not 'ath10k_pci'. This probably means we're
> accessing junk data in ath10k_snoc_rx_replenish_retry(), unless
> 'ath10k_snoc' and 'ath10k_pci' happen to have very similar struct
> layouts.
> 
> Noticed by inspection.
> 
> Fixes: d915105231ca ("ath10k: add hif rx methods for wcn3990")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

4 patches applied to ath-next branch of ath.git, thanks.

426a0f0b5a2f ath10k: snoc: use correct bus-specific pointer in RX retry
8ac5fe8e3d11 ath10k: snoc: stop including pci.h
13e6cc0bd4ef ath10k: snoc: drop unused WCN3990_CE_ATTR_FLAGS
c9f3e7fa8bcb ath10k: snoc: sort include files

-- 
https://patchwork.kernel.org/patch/10458863/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
