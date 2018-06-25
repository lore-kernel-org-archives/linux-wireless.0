Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42580 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752553AbeFYISO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 04:18:14 -0400
Received: by mail-ed1-f68.google.com with SMTP id g12-v6so207675edi.9
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2018 01:18:13 -0700 (PDT)
Subject: Re: [PATCH 0/6] brcmfmac: fix 160MHz support and monitor mode
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
 <CACna6rwzS-KXZ80wudpNEcrtnPd7fUWYKbT93hfFMfQi-V-hhg@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B30A542.7090400@broadcom.com> (sfid-20180625_101837_150743_D4691605)
Date: Mon, 25 Jun 2018 10:18:10 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rwzS-KXZ80wudpNEcrtnPd7fUWYKbT93hfFMfQi-V-hhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/24/2018 1:48 PM, Rafał Miłecki wrote:
> On Fri, 22 Jun 2018 at 20:45, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> Here a couple of patches in preparation of monitor mode support. It
>> is mostly about querying firmware for support. While at it I stumbled
>> upon the fact that 160MHz was not completely implemented in the driver
>> so there is a patch for that as well.
>>
>> The first two patches are actually some changes to the patches that
>> Rafal submitted. So this series depend on:
>>
>> [V3,2/2] brcmfmac: handle monitor mode marked msgbuf packets [1]
>>
>> These apply to the master branch of the wireless-drivers-next repository.
>>
>> [1] https://patchwork.kernel.org/patch/10474799/
>
> I find it pointless to submit fixes for patches that weren't accepted
> yet. Let's work on improving original patches while they are still
> pending.

It is not unprecedented. There are enough patch series sent in the past 
that relied on other still pending series. I was unsure how to deal with 
it as I acked your changes already and did not exactly know when Kalle 
would start applying the patches. I am fine either way.

Regards,
Arend
