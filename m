Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2104 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbcJFHn4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 03:43:56 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Marty Faltesek <mfaltesek@google.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: cache calibration data when the core is stopped.
Date: Thu, 6 Oct 2016 07:40:48 +0000
Message-ID: <87r37ukjr5.fsf@kamboji.qca.qualcomm.com> (sfid-20161006_094400_006267_105B0379)
References: <1473801118-103112-1-git-send-email-mfaltesek@google.com>
        <87fuodswlu.fsf@kamboji.qca.qualcomm.com>
        <CAOiWkA_fuhzPeF7qPP0hLN3KTZUOi6_te5Zc3+vxKQ9GRj0VBw@mail.gmail.com>
In-Reply-To: <CAOiWkA_fuhzPeF7qPP0hLN3KTZUOi6_te5Zc3+vxKQ9GRj0VBw@mail.gmail.com>       (Marty
 Faltesek's message of "Wed, 5 Oct 2016 12:39:48 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marty Faltesek <mfaltesek@google.com> writes:

> On Mon, Oct 3, 2016 at 3:46 AM, Valo, Kalle <kvalo@qca.qualcomm.com> wrot=
e:
>> Marty Faltesek <mfaltesek@google.com> writes:
>>
>>> Caching calibration data allows it to be accessed when the
>>> device is not active.
>>>
>>> Signed-off-by: Marty Faltesek <mfaltesek@google.com>
>>
>> No comma in the title, please.
>>
>> What tree did you use as the baseline? This doesn't seem to apply to
>> ath.git:
>
> We use backports 20160122 which has not been updated since earlier this y=
ear.
> I can forward port it to your tree, and make sure
> it builds but won't be able to test it. Will that be OK?

Sure, I can test it.

>> Also please note that this patch (which I'm queuing to 4.9) touches the
>> same area:
>>
>> ath10k: fix debug cal data file
>>
>> https://patchwork.kernel.org/patch/9340953/
>
> I've modified this too, and this won't be necessary, so can you drop
> it? If not, let me know and I'll pull it in and make sure I'm based
> off it too.

Actually I was first planning to push 9340953 to 4.9 and take your patch
to 4.10. But your patch is a cleaner approach to this and maybe I should
push that to 4.9 instead? Need to think a bit more.

--=20
Kalle Valo=
