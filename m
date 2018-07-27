Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52172 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388075AbeG0RH3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 13:07:29 -0400
Subject: Re: [PATCH 03/10] atmel: hide unused procfs helpers
To: Kalle Valo <kvalo@codeaurora.org>,
        YueHaibing <yuehaibing@huawei.com>
Cc: simon@thekelleys.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net
References: <20180713064658.10340-1-yuehaibing@huawei.com>
 <ded55181-e1b0-99e9-ac68-2d93fb6168c0@huawei.com>
 <87va91vxnr.fsf@codeaurora.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e6100005-2c8e-b1b9-2870-b8ca2d61fe30@infradead.org> (sfid-20180727_174521_103895_5752D7D8)
Date: Fri, 27 Jul 2018 08:44:54 -0700
MIME-Version: 1.0
In-Reply-To: <87va91vxnr.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/27/2018 02:24 AM, Kalle Valo wrote:
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
> 
> I'm asking because I prefer this over Randy's version:
> 
> https://patchwork.kernel.org/patch/10512913/

Take it.  I don't mind.

-- 
~Randy
