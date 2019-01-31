Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23518C282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 01:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0ADF2184D
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 01:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbfAaBx5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 20:53:57 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:52332 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725535AbfAaBx5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 20:53:57 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 451A05408F5F76B2680D;
        Thu, 31 Jan 2019 09:53:54 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.408.0; Thu, 31 Jan 2019
 09:53:52 +0800
Subject: Re: [PATCH] rtlwifi: remove set but not used variable 'cmd_seq'
To:     Kalle Valo <kvalo@codeaurora.org>, Pkshih <pkshih@realtek.com>
References: <1536667978-10556-1-git-send-email-yuehaibing@huawei.com>
 <581817ea-a414-e6ed-3615-5e44837a5221@huawei.com>
 <e37bae9c-c920-56cf-7813-0004c017f02a@huawei.com>
 <1548811903.17195.1.camel@realtek.com>
 <87zhrijuay.fsf@kamboji.qca.qualcomm.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <4f394762-a640-6beb-d8e4-90e4e97b83a1@huawei.com>
Date:   Thu, 31 Jan 2019 09:53:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <87zhrijuay.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 2019/1/30 18:47, Kalle Valo wrote:
> Pkshih <pkshih@realtek.com> writes:
> 
>> On Tue, 2019-01-29 at 14:03 +0800, YueHaibing wrote:
>>> +cc netdev@vger.kernel.org
>>>
>>> On 2019/1/29 13:57, YueHaibing wrote:
>>>> ping...
>>>>  
>>>> On 2018/9/11 20:12, YueHaibing wrote:
>>>>> Fixes gcc '-Wunused-but-set-variable' warning:
>>>>>
>>>>> drivers/net/wireless/realtek/rtlwifi/base.c: In function
>>> 'rtl_c2h_content_parsing':
>>>>> drivers/net/wireless/realtek/rtlwifi/base.c:2313:13: warning:
>>>>>   variable 'cmd_seq' set but not used [-Wunused-but-set-variable]
>>>>>
>>>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>
>> Thanks for your fix.
>>
>> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> 
> For some reason I couldn't find the original patch from patchwork.
> I didn't find the version sent today though:
> 
> https://patchwork.kernel.org/patch/10787619/
> 
> BTW YueHaibing, you can check the linux-wireless patch status yourself from
> the patchwork:

Thanks, I'll check it.


> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork
> 

