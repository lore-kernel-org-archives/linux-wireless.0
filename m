Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34618 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbcJFU3J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 16:29:09 -0400
Received: by mail-oi0-f41.google.com with SMTP id n132so35225983oih.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2016 13:29:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r37ukjr5.fsf@kamboji.qca.qualcomm.com>
References: <1473801118-103112-1-git-send-email-mfaltesek@google.com>
 <87fuodswlu.fsf@kamboji.qca.qualcomm.com> <CAOiWkA_fuhzPeF7qPP0hLN3KTZUOi6_te5Zc3+vxKQ9GRj0VBw@mail.gmail.com>
 <87r37ukjr5.fsf@kamboji.qca.qualcomm.com>
From: Marty Faltesek <mfaltesek@google.com>
Date: Thu, 6 Oct 2016 16:29:08 -0400
Message-ID: <CAOiWkA92pCLz3jbbhcs0ba_mbwfUscrdGVN_D2W03PANBp_DmQ@mail.gmail.com> (sfid-20161006_222913_713681_4993A31E)
Subject: Re: [PATCH] ath10k: cache calibration data when the core is stopped.
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK the v2 patch is not based on 9340953. If you  queue this in 4.10 as
planned then just let me know and
I'll rev v3 based on top of 9340953.

On Thu, Oct 6, 2016 at 3:40 AM, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Marty Faltesek <mfaltesek@google.com> writes:
>
>> On Mon, Oct 3, 2016 at 3:46 AM, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
>>> Marty Faltesek <mfaltesek@google.com> writes:
>>>
>>>> Caching calibration data allows it to be accessed when the
>>>> device is not active.
>>>>
>>>> Signed-off-by: Marty Faltesek <mfaltesek@google.com>
>>>
>>> No comma in the title, please.
>>>
>>> What tree did you use as the baseline? This doesn't seem to apply to
>>> ath.git:
>>
>> We use backports 20160122 which has not been updated since earlier this year.
>> I can forward port it to your tree, and make sure
>> it builds but won't be able to test it. Will that be OK?
>
> Sure, I can test it.
>
>>> Also please note that this patch (which I'm queuing to 4.9) touches the
>>> same area:
>>>
>>> ath10k: fix debug cal data file
>>>
>>> https://patchwork.kernel.org/patch/9340953/
>>
>> I've modified this too, and this won't be necessary, so can you drop
>> it? If not, let me know and I'll pull it in and make sure I'm based
>> off it too.
>
> Actually I was first planning to push 9340953 to 4.9 and take your patch
> to 4.10. But your patch is a cleaner approach to this and maybe I should
> push that to 4.9 instead? Need to think a bit more.
>
> --
> Kalle Valo
