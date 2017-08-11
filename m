Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:36496 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbdHKIYM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 04:24:12 -0400
Received: by mail-qt0-f169.google.com with SMTP id v29so17409928qtv.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Aug 2017 01:24:12 -0700 (PDT)
Subject: Re: brcmfmac: BCM43431 won't get probed on Raspberry Pi Zero W
To: Stefan Wahren <stefan.wahren@i2se.com>
References: <384537059.123625.1498678388857@email.1und1.de>
 <1133935948.74840.1500297053336@email.1und1.de>
 <CA+8PC_eKn_LddvcpYG=V6vD7qZfVNEmmzR3gWXxWO80SNKR-3Q@mail.gmail.com>
 <1389331679.85833.1500323470395@email.1und1.de>
 <314866679.136055.1501049965582@email.1und1.de>
 <597857D6.4010508@broadcom.com>
 <683db4ef-662f-3ef2-f69a-c78ca8297115@i2se.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-rpi-kernel@lists.infradead.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <598D69AA.6070206@broadcom.com> (sfid-20170811_102417_728549_4C921D96)
Date: Fri, 11 Aug 2017 10:24:10 +0200
MIME-Version: 1.0
In-Reply-To: <683db4ef-662f-3ef2-f69a-c78ca8297115@i2se.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/11/2017 7:55 AM, Stefan Wahren wrote:
> Hi Arend,
>
> Am 26.07.2017 um 10:50 schrieb Arend van Spriel:
>> On 7/26/2017 8:19 AM, Stefan Wahren wrote:
>>> Hi,
>>>
>>>
>>> what are the plans to fix this regression?
>>
>> I am a bit in doubt about this one. We can avoid the firmware config
>> above for bcm4343x devices as a short term fix. However, I would like
>> to root cause the issue. Received a Pi Zero over here so gearing it up.
>>
>> Regards,
>> Arend
>>
> is there an update about this issue? Should i prepare such a short term fix?

This got a bit snowed under. Thanks for the reminder. I will prepare the 
short term fix shortly.

Regards,
Arend
