Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC91C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 02:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3A3B2077B
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 02:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfAQClx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 21:41:53 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:2178 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbfAQClw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 21:41:52 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1757951621F4130A19C9;
        Thu, 17 Jan 2019 10:41:50 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.408.0; Thu, 17 Jan 2019
 10:41:48 +0800
Subject: Re: [PATCH] mac80211-next: remove duplicated include from virt_wifi.c
To:     Kalle Valo <kvalo@codeaurora.org>
References: <1545274285-143886-1-git-send-email-yuehaibing@huawei.com>
 <cfdac00b-ea9a-1805-4668-64e44c523f6d@huawei.com>
 <87va2o4ma7.fsf@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <282cdf9e-55c6-19a8-756a-8dd5843d887d@huawei.com>
Date:   Thu, 17 Jan 2019 10:41:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <87va2o4ma7.fsf@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 2019/1/17 0:09, Kalle Valo wrote:
> YueHaibing <yuehaibing@huawei.com> writes:
> 
>> ping...
>>
>> On 2018/12/20 10:51, YueHaibing wrote:
>>> Remove duplicated include.
>>>
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>> ---
>>>  drivers/net/wireless/virt_wifi.c | 5 -----
>>>  1 file changed, 5 deletions(-)
> 
> BTW, the prefix should be "virt_wifi:".

Thanks ,will fix it in v2
> 

