Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbdFNJN2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 05:13:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: amit karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [PATCH 2/6] rsi: use enum for FSM states
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
        <1496412785-8720-3-git-send-email-amit.karwar@redpinesignals.com>
        <87lgowpeno.fsf@purkki.adurom.net>
        <CAEhWJFmzEotu+MpKaHqtXFnWyQWsekk23+Pj-3z8oEVmy2Z2DQ@mail.gmail.com>
Date: Wed, 14 Jun 2017 12:13:22 +0300
In-Reply-To: <CAEhWJFmzEotu+MpKaHqtXFnWyQWsekk23+Pj-3z8oEVmy2Z2DQ@mail.gmail.com>
        (amit karwar's message of "Tue, 13 Jun 2017 20:17:32 +0530")
Message-ID: <87zidb2aq5.fsf@kamboji.qca.qualcomm.com> (sfid-20170614_111455_857118_21137D2F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

amit karwar <amitkarwar@gmail.com> writes:

> On Tue, Jun 13, 2017 at 12:17 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>>
>>> Currently macros are used for FSM states. We will replace
>>> it with enum so that new state can be added easily without
>>> worrying about macro value.
>>>
>>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>>
>> From and Signed-off-by does not match (gmail.com vs redpinesignals.com).
>> I suggest that you add a separate From line to the commit log containing
>> redpinesignals.com, this way you can still submit patches via gmail.com.
>
> Sure. I will follow this for my future patches.

Actually please resend this series with matching From and S-o-b. I don't
want to edit From headers myself.

>> Also your name in patchwork is not capitalised (patchwork is idiotic and
>> takes the name from patchwork user data and not from the patch):
>>
>>       [1/6] rsi: add usb RS9113 chipset support 2017-06-02 amit
>> karwar New
>>       [2/6] rsi: use enum for FSM states 2017-06-02 amit karwar New
>>       [3/6] rsi: Register interrupt handler before firmware load
>> 2017-06-02 amit karwar New
>>       [4/6] rsi: receive path enhancement for RS9113 2017-06-02 amit
>> karwar New
>>       [5/6] rsi: configure new boot parameters to device 2017-06-02
>> amit karwar New
>>       [6/6] rsi: add tx frame for common device configuration
>> 2017-06-02 amit karwar New
>>
>> To fix that could you please register to patchwork and capitalise your
>> name correctly? You have only one chance, patchwork doesn't allow users
>> edit the name afterwards, so don't do any typos :)
>
> Thanks. I have registered with patchwork and corrected my name.

What address did you use? Patchwork still shows your name all lower:

https://patchwork.kernel.org/project/linux-wireless/list/?submitter=173645

I suspect you didn't register with gmail.com, but with some other
address. I recommend that you link all your email addresses, including
gmail.com, to the same patchwork account and hopefully that fixes it.
You should be able to do that from the profile page in patchwork.

-- 
Kalle Valo
