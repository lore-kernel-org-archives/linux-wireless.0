Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32862 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752141AbeFDK1t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 06:27:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Subject: Re: [PATCH net-next] ath10k: make some functions static
References: <1527733994-149212-1-git-send-email-weiyongjun1@huawei.com>
Date: Mon, 04 Jun 2018 13:27:43 +0300
In-Reply-To: <1527733994-149212-1-git-send-email-weiyongjun1@huawei.com> (Wei
        Yongjun's message of "Thu, 31 May 2018 02:33:14 +0000")
Message-ID: <87a7sazw0w.fsf@kamboji.qca.qualcomm.com> (sfid-20180604_122759_676187_1CCCDB42)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun <weiyongjun1@huawei.com> writes:

> Fixes the following sparse warnings:
>
> drivers/net/wireless/ath/ath10k/snoc.c:823:5: warning:
>  symbol 'ath10k_snoc_get_ce_id_from_irq' was not declared. Should it be static?
> drivers/net/wireless/ath/ath10k/snoc.c:871:6: warning:
>  symbol 'ath10k_snoc_init_napi' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

BTW this goes to my ath.git tree, not to net-next.

I had missed these as I can't enable ATH10K_SNOC on x86 and hence I
don't test compile snoc.c at all. Bjorn&Govind, is there a way to solve
that? IIRC we had a similar problem with wcn36xx but I don't remember
anymore how it was fixed.

-- 
Kalle Valo
