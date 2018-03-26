Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46288 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbeCZP1v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 11:27:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Check DXE IRQ reason
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180311120143.29726-1-rfried@codeaurora.org>
References: <20180311120143.29726-1-rfried@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, Ramon Fried <rfried@codeaurora.org>
Message-Id: <20180326152750.B25EF60AFB@smtp.codeaurora.org> (sfid-20180326_172754_155032_D3F113D3)
Date: Mon, 26 Mar 2018 15:27:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> wrote:

> IRQ reason was not cheked for errors.
> Although error handing is not currently supported, it
> will be nice to output an error value to the log if the
> DMA operation failed.
> 
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6767b302e1c9 wcn36xx: Check DXE IRQ reason

-- 
https://patchwork.kernel.org/patch/10274695/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
