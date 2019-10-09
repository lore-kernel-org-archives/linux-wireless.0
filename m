Return-Path: <SRS0=Z1rL=YC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E249CECE58D
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 13:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6FE921721
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 13:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbfJINHa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Oct 2019 09:07:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3671 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730858AbfJINH3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Oct 2019 09:07:29 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 177F39A6B016244B3259;
        Wed,  9 Oct 2019 21:07:26 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 9 Oct 2019
 21:07:21 +0800
Subject: Re: [PATCH RESEND] rtlwifi: rtl8192ee: Remove set but not used
 variable 'err'
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
 <8736g2rs86.fsf@codeaurora.org>
 <0135c3c7-a827-941a-1bad-90129c49d0ac@huawei.com>
 <87y2xuqdbo.fsf@codeaurora.org>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <e9c16275-16bc-25d0-9761-abcb0e47b2f4@huawei.com>
Date:   Wed, 9 Oct 2019 21:06:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <87y2xuqdbo.fsf@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 2019/10/9 21:05, Kalle Valo wrote:
> "zhengbin (A)" <zhengbin13@huawei.com> writes:
>
>> On 2019/10/9 20:58, Kalle Valo wrote:
>>> zhengbin <zhengbin13@huawei.com> writes:
>>>
>>>> Fixes gcc '-Wunused-but-set-variable' warning:
>>>>
>>>> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
>>>> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning:
>>>> variable err set but not used [-Wunused-but-set-variable]
>>>>
>>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
>>>> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
>>> There's no changelog, why did you resend? Document clearly the changes
>>> so that maintainers don't need to guess what has changed:
>> Failed to apply:
>>
>> fatal: corrupt patch at line 13
>> error: could not build fake ancestor
>> Applying: rtlwifi: rtl8192ee: Remove set but not used variable 'err'
>> Patch failed at 0001 rtlwifi: rtl8192ee: Remove set but not used variable 'err'
>> The copy of the patch that failed is found in: .git/rebase-apply/patch
>>
>> So I resend this. 
> Ok, thanks. But next time include the changelog automatically and mark
> the patch as v2. And read the documentation:
Copy that, thank your for your patience
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>

