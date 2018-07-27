Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44398 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbeG0Kpr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 06:45:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <simon@thekelleys.org.uk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <rdunlap@infradead.org>
Subject: Re: [PATCH 03/10] atmel: hide unused procfs helpers
References: <20180713064658.10340-1-yuehaibing@huawei.com>
        <ded55181-e1b0-99e9-ac68-2d93fb6168c0@huawei.com>
Date: Fri, 27 Jul 2018 12:24:40 +0300
In-Reply-To: <ded55181-e1b0-99e9-ac68-2d93fb6168c0@huawei.com>
        (yuehaibing@huawei.com's message of "Fri, 13 Jul 2018 17:31:37 +0800")
Message-ID: <87va91vxnr.fsf@codeaurora.org> (sfid-20180727_112501_657020_7146EF80)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(fixing top posting)

YueHaibing <yuehaibing@huawei.com> writes:

> On 2018/7/13 14:46, YueHaibing wrote:
>> When CONFIG_PROC_FS isn't set, gcc warning this:
>>=20
>> drivers/net/wireless/atmel/atmel.c:1402:12: warning: =E2=80=98atmel_proc=
_show=E2=80=99 defined but not used [-Wunused-function]
>>  static int atmel_proc_show(struct seq_file *m, void *v)
>>             ^
>> fix this by adding #ifdef around it.
>>=20
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>
> pls ignore this,my bad.

Why should I drop this? Does the patch have something wrong which I'm
missing?

I'm asking because I prefer this over Randy's version:

https://patchwork.kernel.org/patch/10512913/

--=20
Kalle Valo
