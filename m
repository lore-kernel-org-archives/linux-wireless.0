Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934279AbeFMJ51 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 05:57:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Niklas Cassel <niklas.cassel@linaro.org>, kbuild-all@01.org,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ath10k: ath10k_snoc_get_ce_id_from_irq() can be static
References: <20180612113907.15043-2-niklas.cassel@linaro.org>
        <20180612145037.GA95182@lkp-ib03>
Date: Wed, 13 Jun 2018 12:57:22 +0300
In-Reply-To: <20180612145037.GA95182@lkp-ib03> (kbuild test robot's message of
        "Tue, 12 Jun 2018 22:50:37 +0800")
Message-ID: <87d0wvau0t.fsf@kamboji.qca.qualcomm.com> (sfid-20180613_115743_082833_321AF321)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <fengguang.wu@intel.com> writes:

> Fixes: aecf55e7df3a ("ath10k: allow ATH10K_SNOC with COMPILE_TEST")
> Signed-off-by: kbuild test robot <fengguang.wu@intel.com>

There's already an identical patch pending:

ath10k: make some functions static

https://patchwork.kernel.org/patch/10440159/

-- 
Kalle Valo
