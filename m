Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:36624 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753059AbdFPPCY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 11:02:24 -0400
Received: by mail-qt0-f175.google.com with SMTP id u19so66594830qta.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 08:02:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r2yle2en.fsf@codeaurora.org>
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
 <1496412785-8720-3-git-send-email-amit.karwar@redpinesignals.com>
 <87lgowpeno.fsf@purkki.adurom.net> <CAEhWJFmzEotu+MpKaHqtXFnWyQWsekk23+Pj-3z8oEVmy2Z2DQ@mail.gmail.com>
 <87zidb2aq5.fsf@kamboji.qca.qualcomm.com> <CAEhWJFmXJSJNJxppNtfK-vTRaq1vCZckWChW++TCfj8j8-ZwAg@mail.gmail.com>
 <87r2yle2en.fsf@codeaurora.org>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Fri, 16 Jun 2017 20:32:22 +0530
Message-ID: <CAEhWJFkxg1FnW65E3k-i6sWe1S67gQhr8=9zAZCiyNo4b6Ag6A@mail.gmail.com> (sfid-20170616_170228_081592_1AD56E61)
Subject: Re: [PATCH 2/6] rsi: use enum for FSM states
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 15, 2017 at 8:14 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> On Wed, Jun 14, 2017 at 2:43 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> amit karwar <amitkarwar@gmail.com> writes:
>>>
>>>> On Tue, Jun 13, 2017 at 12:17 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>>
>>>>> Also your name in patchwork is not capitalised (patchwork is idiotic and
>>>>> takes the name from patchwork user data and not from the patch):
>>>>>
>>>>>       [1/6] rsi: add usb RS9113 chipset support 2017-06-02 amit
>>>>> karwar New
>>>>>       [2/6] rsi: use enum for FSM states 2017-06-02 amit karwar New
>>>>>       [3/6] rsi: Register interrupt handler before firmware load
>>>>> 2017-06-02 amit karwar New
>>>>>       [4/6] rsi: receive path enhancement for RS9113 2017-06-02 amit
>>>>> karwar New
>>>>>       [5/6] rsi: configure new boot parameters to device 2017-06-02
>>>>> amit karwar New
>>>>>       [6/6] rsi: add tx frame for common device configuration
>>>>> 2017-06-02 amit karwar New
>>>>>
>>>>> To fix that could you please register to patchwork and capitalise your
>>>>> name correctly? You have only one chance, patchwork doesn't allow users
>>>>> edit the name afterwards, so don't do any typos :)
>>>>
>>>> Thanks. I have registered with patchwork and corrected my name.
>>>
>>> What address did you use? Patchwork still shows your name all lower:
>>>
>>> https://patchwork.kernel.org/project/linux-wireless/list/?submitter=173645
>>>
>>> I suspect you didn't register with gmail.com, but with some other
>>> address. I recommend that you link all your email addresses, including
>>> gmail.com, to the same patchwork account and hopefully that fixes it.
>>> You should be able to do that from the profile page in patchwork.
>>
>> I had registered with my gmail id. Also, other email id has also been
>> linked to patchwork. But still patchwork took previous user name.
>> I could not find a way to check my name in patchwork database after
>> login. I have now corrected my display name in gmail's setting.
>
> Good, thanks. This name format bug in patchwork is really annoying, I'm
> suffering from frequently. Let's see how your next submission goes and
> hopefully we can sort it out.

I just submitted a patch series. But patchwork is still showing older name.

Regards,
Amitkumar
