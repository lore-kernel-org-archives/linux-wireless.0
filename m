Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4057C282D0
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 01:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A7C021473
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 01:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfA3Bb7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 20:31:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3238 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727525AbfA3Bb7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 20:31:59 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9805FCC2E041A31C0226;
        Wed, 30 Jan 2019 09:31:56 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.408.0; Wed, 30 Jan 2019
 09:31:52 +0800
Subject: Re: [PATCH] ath10k: snoc: remove set but not used variable 'ar_snoc'
To:     Brian Norris <briannorris@chromium.org>
References: <1536200965-121172-1-git-send-email-yuehaibing@huawei.com>
 <4b16caf3-9a25-99d0-5b35-f27d6e5a5c65@huawei.com>
 <CA+ASDXMQto_dqPOuUEX9vqqbWmor8qvpwxBVTg6tSnHkfsCzpw@mail.gmail.com>
CC:     Kalle Valo <kvalo@codeaurora.org>, <ath10k@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <a2b059fe-e527-0cff-2114-26f5bdaf7443@huawei.com>
Date:   Wed, 30 Jan 2019 09:31:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CA+ASDXMQto_dqPOuUEX9vqqbWmor8qvpwxBVTg6tSnHkfsCzpw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 2019/1/30 2:12, Brian Norris wrote:
> On Mon, Jan 28, 2019 at 9:53 PM YueHaibing <yuehaibing@huawei.com> wrote:
>>
>> ping...
> 
> For some reason, your patch shows up as Deferred in patchwork:
> 
> https://patchwork.kernel.org/patch/10589789/
> 
> So the maintainers have accidentally (?) ignored it. I'm not what the
> official suggestion is for that, but you might just resend.

Thank you for your review,  I'll resend it.

> 
> In any case...
> 
>> On 2018/9/6 10:29, YueHaibing wrote:
>>> From: Yue Haibing <yuehaibing@huawei.com>
>>>
>>> Fixes gcc '-Wunused-but-set-variable' warning:
>>>
>>> drivers/net/wireless/ath/ath10k/snoc.c: In function 'ath10k_snoc_tx_pipe_cleanup':
>>> drivers/net/wireless/ath/ath10k/snoc.c:681:22: warning:
>>>  variable 'ar_snoc' set but not used [-Wunused-but-set-variable]
>>>
>>> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> 
> ...patch looks fine to me:
> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> 
> 

