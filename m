Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33517 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbdCQTtZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 15:49:25 -0400
Received: by mail-lf0-f67.google.com with SMTP id r36so6193797lfi.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Mar 2017 12:49:24 -0700 (PDT)
Subject: Re: [RFC v4 06/21] ath10k: sdio support
To: Kalle Valo <kvalo@qca.qualcomm.com>
References: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
 <1487693741-10042-7-git-send-email-erik.stromdahl@gmail.com>
 <8760jh2uy8.fsf@kamboji.qca.qualcomm.com>
 <871su52th2.fsf@kamboji.qca.qualcomm.com>
 <2528f323-6ec7-915c-d98b-615db04510e9@gmail.com>
 <877f3qyc5g.fsf@kamboji.qca.qualcomm.com>
 <29c3dd40-c3ac-746e-d8ef-cb072c58578a@gmail.com>
 <87y3w5tvkq.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <feaa5932-4a2b-d801-9226-5532cea93a14@gmail.com> (sfid-20170317_204959_026669_2313D166)
Date: Fri, 17 Mar 2017 16:54:08 +0100
MIME-Version: 1.0
In-Reply-To: <87y3w5tvkq.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2017-03-16 10:33, Kalle Valo wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>
>>> There seems to be same pattern for reading four bytes, what if we should
>>> add a helper for that? Something like ath10k_sdio_read32()? It could
>>> handle the kmalloc and switch endianess also.
>>>
>>> But please don't make any chances to sdio.c for the moment, let me
>>> submit v5 first.
>>>
>> I notice that you have submitted v5 (and v6) of the sdio patches. Great!
>>
>> I assume you will add them to master-pending soon so I will try out
>> everything (usb too) as soon as they are on master-pending.
>
> v6 is now in master-pending.
>

I have added my usb patches on top of sdio v6 and everything works as expected
(both usb and sdio).

Your changes does not seem to have broken anything.
