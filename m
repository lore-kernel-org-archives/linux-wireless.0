Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbeB0QOt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:14:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ssb: return boolean instead of integer in
 ssb_dma_translation_special_bit
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180118235428.GA25892@embeddedor.com>
References: <20180118235428.GA25892@embeddedor.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-Id: <20180227161448.CD2C860849@smtp.codeaurora.org> (sfid-20180227_171504_603632_43A261B6)
Date: Tue, 27 Feb 2018 16:14:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> wrote:

> Return statements in functions returning bool should use
> true/false instead of 1/0.
> 
> This issue was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

bd42cd022e44 ssb: return boolean instead of integer in ssb_dma_translation_special_bit

-- 
https://patchwork.kernel.org/patch/10174387/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
