Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51118 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966712AbdDUGza (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 02:55:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH 00/14] rtlwifi: btcoex: Second set of changes for rtl8821ae 2ant
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
        <87zifb65eh.fsf@codeaurora.org>
        <5df931fe-cbb8-a0f7-ec0f-a62180ca760d@lwfinger.net>
Date: Fri, 21 Apr 2017 09:55:23 +0300
In-Reply-To: <5df931fe-cbb8-a0f7-ec0f-a62180ca760d@lwfinger.net> (Larry
        Finger's message of "Thu, 20 Apr 2017 13:54:22 -0500")
Message-ID: <87lgqu45d0.fsf@kamboji.qca.qualcomm.com> (sfid-20170421_085608_588275_620A24C0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 04/19/2017 11:59 PM, Kalle Valo wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>
>>> These patches are the second set of patches for file
>>> btcoexist/halbtc8821a2ant.c.
>>>
>>> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>> Cc: Pkshih <pkshih@realtek.com>
>>> Cc: Birming Chiu <birming@realtek.com>
>>> Cc: Shaofu <shaofu@realtek.com>
>>> Cc: Steven Ting <steventing@realtek.com>
>>
>> BTW, please try to limit the amount of patches you send. I haven't
>> counted how many rtlwifi patches there are from the last week but it's
>> just too much, even if they are in smaller sets like this one. Reviewing
>> them is just too tedious when you see that you have something like 50
>> more still to go.
>>
>> If you send two sets with reasonable size[1] per week I don't have any
>> problems. But if you send five such sets per week I will get annoyed :)
>> So try to strect the submission a bit to stay below ~30 patches per week
>> limit, please.
>>
>> So I'm not sure if I'm able to apply all of pending rtlwifi patches
>> before the merge window opens, but I'll try.
>>
>> [1] a reasonable size is around a dozen patches per set
>
> Kalle,
>
> Sorry about the heavy load. I received the patches from Realtek late
> in the 4.12 cycle, and I was trying to make the deadline.

Yeah, I guessed it was something like that.

> Please drop the following sets of patches:
>
> [PATCH 00/10] rtlwifi: btcoex: Third set of changes for rtl8821ae 2ant
> [PATCH 00/13] rtlwifi: btcoex: Second set of 21a 1ant changes
> [PATCH 00/27] rtlwifi: btcoex: Changes for 23b 1ant
> [PATCH 0/2] rtlwifi: btcoex: Two more patches

Ok, I dropped these now from patchwork.

But what should I do with this one:

rtlwifi: rtl8821ae: setup 8812ae RFE according to device type
https://patchwork.kernel.org/patch/9683395/

> I believe that is all of the sets that have not yet been merged.

Correct, they were in deferred state as I didn't have time to review
them earlier this week.

> We will fix the issue of the conditionals that you asked about in a
> second E-mail. That is the one that my Chinese Colleagues ask about in
> Chinese.
>
> These will be resubmitted for the 4.13 cycle in smaller sets and no
> more than two sets per week.

That sounds good, thanks! And if we get lucky and Linus doesn't open the
merge window on Sunday we will have one more week to get the patches
applied to 4.12.

-- 
Kalle Valo
