Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33516 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754882AbeDCIWO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 04:22:14 -0400
Received: by mail-qk0-f194.google.com with SMTP id d206so17745019qkb.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 01:22:13 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: add support for BCM4366E chipset
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1521734286-16293-1-git-send-email-dan.haab@luxul.com>
 <5AB4C986.1090709@broadcom.com>
 <CACna6rzfCA3VyiG2bCNY5eHRo9LGsvNa5Tmb23gyDeFBJHcQZg@mail.gmail.com>
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
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com, Dan Haab <dhaab@luxul.com>,
        Dan Haab <dan.haab@luxul.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AC339B0.6070408@broadcom.com> (sfid-20180403_102217_918167_33338C45)
Date: Tue, 3 Apr 2018 10:22:08 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rzfCA3VyiG2bCNY5eHRo9LGsvNa5Tmb23gyDeFBJHcQZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/30/2018 9:26 AM, Rafał Miłecki wrote:
> On 23 March 2018 at 10:31, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 3/22/2018 4:58 PM, Dan Haab wrote:
>>>
>>> From: Dan Haab <dhaab@luxul.com>
>>>
>>> BCM4366E is a wireless chipset with a BCM43664 ChipCommon. It's
>>> supported by the same firmware as 4366c0.
>>
>>
>> Thanks, Dan
>>
>> I have a patch for that queued up already. So let me push that instead.
>
> Arend: is there some actual problem with this patch? Other than you
> have a similar one queued?
>
> I'd prefer to just accept it as it's already there, it was sent first
> and it looks alright. It hopefully won't be too hard to rebase your
> queued work on top of this trivial patch.

My first reaction to this email needed to some cooldown time, but 
managed to swallow it. I actually had a couple of issues with the patch 
and did not want to waste Dan's time when there was a patch ready. I did 
not want to add another device because we are still in the process of 
releasing the firmware for it. Fiddling with radar detection causing the 
delay of that. Another thing is that there is no separate 
BRCMF_FW_NVRAM_DEF() needed for this. And finally, the firmware download 
code has been reworked so this patch needs rebasing.

Regards,
Arend
