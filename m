Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46827 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdHaMOr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 08:14:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: sdio: remove unused struct member
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1503516778-5835-1-git-send-email-erik.stromdahl@gmail.com>
References: <1503516778-5835-1-git-send-email-erik.stromdahl@gmail.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        "Erik Stromdahl" <erik.stromdahl@gmail.com>
Message-ID: <6796e78b3c3c42aba8799767cf21694f@euamsexm01a.eu.qualcomm.com> (sfid-20170831_141450_254077_BE8D3E18)
Date: Thu, 31 Aug 2017 14:14:40 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:

> irq_wq in struct ath10k_sdio is a remnant from an earlier
> version of the sdio patchset.
> 
> Its use was removed as a result of Kalle's review, but somehow
> the struct member survived.
> 
> It is not used and can therefore safely be removed.
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

30b83fff6d97 ath10k: sdio: remove unused struct member

-- 
https://patchwork.kernel.org/patch/9918195/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
