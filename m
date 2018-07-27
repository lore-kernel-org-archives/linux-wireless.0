Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:10142 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732452AbeG0LXo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 07:23:44 -0400
Subject: Re: [PATCH 03/10] atmel: hide unused procfs helpers
To: Kalle Valo <kvalo@codeaurora.org>
References: <20180713064658.10340-1-yuehaibing@huawei.com>
 <ded55181-e1b0-99e9-ac68-2d93fb6168c0@huawei.com>
 <87va91vxnr.fsf@codeaurora.org>
CC: <simon@thekelleys.org.uk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <rdunlap@infradead.org>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <3684c95c-6df1-183e-8940-807dfb49e5bb@huawei.com> (sfid-20180727_120626_903608_8112B190)
Date: Fri, 27 Jul 2018 18:02:29 +0800
MIME-Version: 1.0
In-Reply-To: <87va91vxnr.fsf@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018/7/27 17:24, Kalle Valo wrote:
> (fixing top posting)
> 
> YueHaibing <yuehaibing@huawei.com> writes:
> 
>> On 2018/7/13 14:46, YueHaibing wrote:
>>> When CONFIG_PROC_FS isn't set, gcc warning this:
>>>
>>> drivers/net/wireless/atmel/atmel.c:1402:12: warning: ‘atmel_proc_show’ defined but not used [-Wunused-function]
>>>  static int atmel_proc_show(struct seq_file *m, void *v)
>>>             ^
>>> fix this by adding #ifdef around it.
>>>
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>
>> pls ignore this,my bad.
> 
> Why should I drop this? Does the patch have something wrong which I'm
> missing?

No,the patch is ok,just because I find this issue has a fix patch from Randy.

> 
> I'm asking because I prefer this over Randy's version:
> 
> https://patchwork.kernel.org/patch/10512913/
> 
