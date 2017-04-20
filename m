Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34001 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S946895AbdDTSyY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 14:54:24 -0400
Received: by mail-oi0-f66.google.com with SMTP id y11so10319150oie.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2017 11:54:24 -0700 (PDT)
Subject: Re: [PATCH 00/14] rtlwifi: btcoex: Second set of changes for
 rtl8821ae 2ant
To: Kalle Valo <kvalo@codeaurora.org>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
 <87zifb65eh.fsf@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5df931fe-cbb8-a0f7-ec0f-a62180ca760d@lwfinger.net> (sfid-20170420_205427_987333_D75E3736)
Date: Thu, 20 Apr 2017 13:54:22 -0500
MIME-Version: 1.0
In-Reply-To: <87zifb65eh.fsf@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/19/2017 11:59 PM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> These patches are the second set of patches for file
>> btcoexist/halbtc8821a2ant.c.
>>
>> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Pkshih <pkshih@realtek.com>
>> Cc: Birming Chiu <birming@realtek.com>
>> Cc: Shaofu <shaofu@realtek.com>
>> Cc: Steven Ting <steventing@realtek.com>
>
> BTW, please try to limit the amount of patches you send. I haven't
> counted how many rtlwifi patches there are from the last week but it's
> just too much, even if they are in smaller sets like this one. Reviewing
> them is just too tedious when you see that you have something like 50
> more still to go.
>
> If you send two sets with reasonable size[1] per week I don't have any
> problems. But if you send five such sets per week I will get annoyed :)
> So try to strect the submission a bit to stay below ~30 patches per week
> limit, please.
>
> So I'm not sure if I'm able to apply all of pending rtlwifi patches
> before the merge window opens, but I'll try.
>
> [1] a reasonable size is around a dozen patches per set

Kalle,

Sorry about the heavy load. I received the patches from Realtek late in the 4.12 
cycle, and I was trying to make the deadline.

Please drop the following sets of patches:

[PATCH 00/10] rtlwifi: btcoex: Third set of changes for rtl8821ae 2ant
[PATCH 00/13] rtlwifi: btcoex: Second set of 21a 1ant changes
[PATCH 00/27] rtlwifi: btcoex: Changes for 23b 1ant
[PATCH 0/2] rtlwifi: btcoex: Two more patches

I believe that is all of the sets that have not yet been merged. We will fix the 
issue of the conditionals that you asked about in a second E-mail. That is the 
one that my Chinese Colleagues ask about in Chinese.

These will be resubmitted for the 4.13 cycle in smaller sets and no more than 
two sets per week.

Thanks for all your efforts,

Larry
