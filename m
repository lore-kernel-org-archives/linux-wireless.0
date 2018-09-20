Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59966 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbeITRnH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 13:43:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] b43: fix DMA error related regression with proprietary
 firmware
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180827153407.5612-1-Larry.Finger@lwfinger.net>
References: <20180827153407.5612-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>,
        Taketo Kabe <kabe@sra-tohoku.co.jp>
Message-Id: <20180920115958.A472660BF7@smtp.codeaurora.org> (sfid-20180920_140002_308509_879F1D09)
Date: Thu, 20 Sep 2018 11:59:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> In commit 66cffd6daab7 ("b43: fix transmit failure when VT is switched"),
> a condition is noted where the network controller needs to be reset. Note
> that this situation happens when running the open-source firmware
> (http://netweb.ing.unibs.it/~openfwwf/), plus a number of other special
> conditions.
> 
> for a different card model, it is reported that this change breaks
> operation running the proprietary firmware
> (https://marc.info/?l=linux-wireless&m=153504546924558&w=2). Rather
> than reverting the previous patch, the code is tweaked to avoid the
> reset unless the open-source firmware is being used.
> 
> Fixes: 66cffd6daab7 ("b43: fix transmit failure when VT is switched")
> Cc: Stable <stable@vger.kernel.org> # 4.18+
> Cc: Taketo Kabe <kabe@sra-tohoku.co.jp>
> Reported-and-tested-by: D. Prabhu <d.praabhu@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers.git, thanks.

2823c8716c68 b43: fix DMA error related regression with proprietary firmware

-- 
https://patchwork.kernel.org/patch/10577379/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
