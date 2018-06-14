Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49968 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752928AbeFNIzt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 04:55:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH net-next] ath10k: make some functions static
References: <1527733994-149212-1-git-send-email-weiyongjun1@huawei.com>
Date: Thu, 14 Jun 2018 11:55:44 +0300
In-Reply-To: <1527733994-149212-1-git-send-email-weiyongjun1@huawei.com> (Wei
        Yongjun's message of "Thu, 31 May 2018 02:33:14 +0000")
Message-ID: <87lgbhagrz.fsf@kamboji.qca.qualcomm.com> (sfid-20180614_105554_838078_F3171B9B)
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

Your name in patchwork is wrong[1] and hence my script uses the wrong
name. Please fix it by registering to patchwork[2] where it's possible
to change your name during registration, but only one time. If that
doesn't work then send a request to helpdesk@kernel.org and the admins
can fix it.

But no need to resend this patch, I can fix your name manually this
time.

[1] "weiyongjun (A)" in https://patchwork.kernel.org/patch/10440159/

[2] https://patchwork.kernel.org/register/


-- 
Kalle Valo
