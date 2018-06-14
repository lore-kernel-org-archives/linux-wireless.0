Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59982 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754885AbeFNNzu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 09:55:50 -0400
Date: Thu, 14 Jun 2018 16:55:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH net-next] ath10k: make some functions static
Message-ID: <20180614135515.i47fj4bn47ntn6wb@mwanda> (sfid-20180614_155553_737459_5BC8AE27)
References: <1527733994-149212-1-git-send-email-weiyongjun1@huawei.com>
 <87lgbhagrz.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87lgbhagrz.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 14, 2018 at 11:55:44AM +0300, Kalle Valo wrote:
> Wei Yongjun <weiyongjun1@huawei.com> writes:
> 
> > Fixes the following sparse warnings:
> >
> > drivers/net/wireless/ath/ath10k/snoc.c:823:5: warning:
> >  symbol 'ath10k_snoc_get_ce_id_from_irq' was not declared. Should it be static?
> > drivers/net/wireless/ath/ath10k/snoc.c:871:6: warning:
> >  symbol 'ath10k_snoc_init_napi' was not declared. Should it be static?
> >
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Your name in patchwork is wrong[1] and hence my script uses the wrong
> name. Please fix it by registering to patchwork[2] where it's possible
> to change your name during registration, but only one time. If that
> doesn't work then send a request to helpdesk@kernel.org and the admins
> can fix it.
> 
> But no need to resend this patch, I can fix your name manually this
> time.
> 
> [1] "weiyongjun (A)" in https://patchwork.kernel.org/patch/10440159/
> 
> [2] https://patchwork.kernel.org/register/

That's a weird patchwork issue...  It sounds like this is a known bug?

regards,
dan carpenter
