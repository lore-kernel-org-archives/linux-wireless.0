Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33120 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932131AbeF1JzS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:55:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix bug in masking of TID value
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180615120153.4677-1-erik.stromdahl@gmail.com>
References: <20180615120153.4677-1-erik.stromdahl@gmail.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Message-Id: <20180628095517.BB644608C8@smtp.codeaurora.org> (sfid-20180628_115522_196434_82AAA61A)
Date: Thu, 28 Jun 2018 09:55:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:

> Although the TID mask is 0xf, the modulus operation does still not
> produce identical results as the bitwise and operator. If the TID is 15, the
> modulus operation will "convert" it to 0, whereas the bitwise and will keep it
> as 15.
> 
> This was found during code review.
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d1a566bec588 ath10k: fix bug in masking of TID value

-- 
https://patchwork.kernel.org/patch/10466271/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
