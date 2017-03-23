Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50261 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965361AbdCWQLK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 12:11:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v4 06/21] ath10k: sdio support
Date: Thu, 23 Mar 2017 16:10:45 +0000
Message-ID: <878tnwynwb.fsf@kamboji.qca.qualcomm.com> (sfid-20170323_171123_105578_CCD3780E)
References: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
        <1487693741-10042-7-git-send-email-erik.stromdahl@gmail.com>
        <8760jh2uy8.fsf@kamboji.qca.qualcomm.com>
        <871su52th2.fsf@kamboji.qca.qualcomm.com>
        <2528f323-6ec7-915c-d98b-615db04510e9@gmail.com>
        <877f3qyc5g.fsf@kamboji.qca.qualcomm.com>
        <29c3dd40-c3ac-746e-d8ef-cb072c58578a@gmail.com>
        <87y3w5tvkq.fsf@kamboji.qca.qualcomm.com>
        <feaa5932-4a2b-d801-9226-5532cea93a14@gmail.com>
In-Reply-To: <feaa5932-4a2b-d801-9226-5532cea93a14@gmail.com> (Erik
        Stromdahl's message of "Fri, 17 Mar 2017 16:54:08 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> On 2017-03-16 10:33, Kalle Valo wrote:
>> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>>
>>>> There seems to be same pattern for reading four bytes, what if we shou=
ld
>>>> add a helper for that? Something like ath10k_sdio_read32()? It could
>>>> handle the kmalloc and switch endianess also.
>>>>
>>>> But please don't make any chances to sdio.c for the moment, let me
>>>> submit v5 first.
>>>>
>>> I notice that you have submitted v5 (and v6) of the sdio patches. Great=
!
>>>
>>> I assume you will add them to master-pending soon so I will try out
>>> everything (usb too) as soon as they are on master-pending.
>>
>> v6 is now in master-pending.
>>
>
> I have added my usb patches on top of sdio v6 and everything works as exp=
ected
> (both usb and sdio).
>
> Your changes does not seem to have broken anything.

Great, thanks for testing. I'll try to send v7 tomorrow and hopefully
you have time to test that also. And naturally others are also welcome
to provide feedback and test results.

--=20
Kalle Valo=
