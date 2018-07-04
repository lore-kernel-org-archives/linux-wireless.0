Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46990 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753046AbeGDJ7O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 05:59:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] ath10k: allow ATH10K_SNOC with COMPILE_TEST
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180612113907.15043-2-niklas.cassel@linaro.org>
References: <20180612113907.15043-2-niklas.cassel@linaro.org>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180704095913.85B7F60131@smtp.codeaurora.org> (sfid-20180704_115939_833650_F718FED4)
Date: Wed,  4 Jul 2018 09:59:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Niklas Cassel <niklas.cassel@linaro.org> wrote:

> ATH10K_SNOC builds just fine with COMPILE_TEST, so make that possible.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>

Note to myself, I see these dependencies in linux-next (but not in Linus' tree yet):

67cd0eec5b62 rpmsg: smd: Add missing include of sizes.h
376e1f304fc7 firmware: qcom: scm: add a dummy qcom_scm_assign_mem()

These I don't see in linux-next yet:

  soc: qcom: smem: Add missing include of sizes.h
  soc: qcom: smp2p: Add select IRQ_DOMAIN
  soc: qcom: smsm: Add select IRQ_DOMAIN
  soc: qcom: Remove depends on ARCH_QCOM

-- 
https://patchwork.kernel.org/patch/10460103/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
