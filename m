Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38696 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755335AbeDCLqH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 07:46:07 -0400
Received: by mail-wm0-f68.google.com with SMTP id i3so10794743wmf.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 04:46:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5AC36460.7080902@broadcom.com>
References: <1521734286-16293-1-git-send-email-dan.haab@luxul.com>
 <5AB4C986.1090709@broadcom.com> <CACna6rzfCA3VyiG2bCNY5eHRo9LGsvNa5Tmb23gyDeFBJHcQZg@mail.gmail.com>
 <5AC339B0.6070408@broadcom.com> <CACna6rx+2i+P+F2XRNRm7DrxaiXsoABWARR_XV4rdBXBUFO3bw@mail.gmail.com>
 <5AC36460.7080902@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 3 Apr 2018 13:46:04 +0200
Message-ID: <CACna6rwTKa2CywNMW3FQw5qqfc8cMZ2fD2UVkjD34cs_1W5p6A@mail.gmail.com> (sfid-20180403_134615_891875_64D79270)
Subject: Re: [PATCH] brcmfmac: add support for BCM4366E chipset
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Dan Haab <riproute@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Double Lo <double.lo@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>,"
        <brcm80211-dev-list@cypress.com>, Dan Haab <dhaab@luxul.com>,
        Dan Haab <dan.haab@luxul.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 April 2018 at 13:24, Arend van Spriel <arend.vanspriel@broadcom.com> w=
rote:
> On 4/3/2018 12:17 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
>>
>> On 3 April 2018 at 10:22, Arend van Spriel <arend.vanspriel@broadcom.com=
>
>> wrote:
>
>
> [...]
>
>>>
>>>
>>> My first reaction to this email needed to some cooldown time, but manag=
ed
>>> to
>>> swallow it.
>>
>>
>> I'm sorry you keep reacting to my e-mails/patches that way. I can't
>> see how my e-mail was offensive in any way. I assure I didn't mean it
>> to be.
>
>
> I can not really say what it is. Anyway it is my fault and have to work o=
n
> it.
>
> [...]
>
>>> I actually had a couple of issues with the patch and did not
>>> want to waste Dan's time when there was a patch ready. I did not want t=
o
>>> add
>>> another device because we are still in the process of releasing the
>>> firmware
>>> for it. Fiddling with radar detection causing the delay of that.
>>
>>
>> It's something that I think was never a problem in the past. There is
>> e.g. support for 4366c0 support in the brcmfmac without
>> brcmfmac4366c-pcie.bin officially released.
>
>
> My rule of thumb is to get the firmware released before/when the driver
> patch hits mainline. However, sometimes it blows up in my face. Like with
> the 4366c0. We had to add a new feature to the firmware to get an ok, whi=
ch
> caused the delay. Hopefully, I can get it out soon.

Sounds great, thanks, I keep by fingers crossed :)

--=20
Rafa=C5=82
