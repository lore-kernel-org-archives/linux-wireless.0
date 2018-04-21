Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbeDUHKg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Apr 2018 03:10:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jared Bents <jared.bents@rockwellcollins.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v1 1/1] ath10k: convert kmemdup to dma_alloc_coherent
References: <1524238793-24481-1-git-send-email-jared.bents@rockwellcollins.com>
Date: Sat, 21 Apr 2018 10:10:31 +0300
In-Reply-To: <1524238793-24481-1-git-send-email-jared.bents@rockwellcollins.com>
        (Jared Bents's message of "Fri, 20 Apr 2018 10:39:53 -0500")
Message-ID: <87in8lf314.fsf@kamboji.qca.qualcomm.com> (sfid-20180421_091040_635911_F8E91925)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jared Bents <jared.bents@rockwellcollins.com> writes:

> Update to convert the use of kmemdup to dma_alloc_coherent as
> dma_alloc_coherent will consider DMA region limits such as
> those seen with CONFIG_FSL_PCI && CONFIG_ZONE_DMA32 whereas
> kmemdup does not take those limitations into account.
>
> Signed-off-by: Jared Bents <jared.bents@rockwellcollins.com>

Does this fix a real bug or is it just a theoretical issue you noticed
while looking at the code? If this fixes a real bug please give a
description of it.

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches#guidelines

-- 
Kalle Valo
