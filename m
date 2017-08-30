Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.149.72]:25205 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751415AbdH3RLg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 13:11:36 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 5A0FB12A9E6E
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 11:51:28 -0500 (CDT)
Subject: Re: [PATCH] rtlwifi: btcoex: 23b 1ant: fix duplicated code for
 different branches
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Kalle Valo <kvalo@codeaurora.org>
References: <20170830134223.GA13596@embeddedgus>
 <eef42b52-ae7b-e574-237f-209ac8ec033c@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <34fa2988-93cd-e33d-54c8-a5386d00b414@embeddedor.com> (sfid-20170830_191140_258175_23A73790)
Date: Wed, 30 Aug 2017 11:51:23 -0500
MIME-Version: 1.0
In-Reply-To: <eef42b52-ae7b-e574-237f-209ac8ec033c@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On 08/30/2017 11:37 AM, Larry Finger wrote:
> On 08/30/2017 08:42 AM, Gustavo A. R. Silva wrote:
>> Refactor code in order to avoid identical code for different branches.
>>
>> This issue was detected with the help of Coccinelle.
>>
>> Addresses-Coverity-ID: 1226788
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>> This issue was reported by Coverity and it was tested by compilation
>> only.
>> I'm suspicious this may be a copy/paste error. Please, verify.
>
> I have referred this change to the engineers at Realtek. For the moment,
> please hold this patch.
>
> Thanks for reporting the condition.
>

Glad to help. :)

-- 
Gustavo A. R. Silva
