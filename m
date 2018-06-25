Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:39610 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754021AbeFYIb2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 04:31:28 -0400
Received: by mail-qt0-f194.google.com with SMTP id c23-v6so2308170qtn.6
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2018 01:31:28 -0700 (PDT)
Subject: Re: [PATCH 0/6] brcmfmac: fix 160MHz support and monitor mode
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
 <CACna6rwzS-KXZ80wudpNEcrtnPd7fUWYKbT93hfFMfQi-V-hhg@mail.gmail.com>
 <CACna6rzpUDWBR_SXciEo8Z3Fsa6VZT0-KL2=WCzz9v8ww6tZVA@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B30A85C.5080105@broadcom.com> (sfid-20180625_103309_610615_D08115D8)
Date: Mon, 25 Jun 2018 10:31:24 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rzpUDWBR_SXciEo8Z3Fsa6VZT0-KL2=WCzz9v8ww6tZVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/25/2018 6:40 AM, Rafał Miłecki wrote:
> On Sun, 24 Jun 2018 at 13:48, Rafał Miłecki <zajec5@gmail.com> wrote:
>> On Fri, 22 Jun 2018 at 20:45, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> Here a couple of patches in preparation of monitor mode support. It
>>> is mostly about querying firmware for support. While at it I stumbled
>>> upon the fact that 160MHz was not completely implemented in the driver
>>> so there is a patch for that as well.
>>>
>>> The first two patches are actually some changes to the patches that
>>> Rafal submitted. So this series depend on:
>>>
>>> [V3,2/2] brcmfmac: handle monitor mode marked msgbuf packets [1]
>>>
>>> These apply to the master branch of the wireless-drivers-next repository.
>>>
>>> [1] https://patchwork.kernel.org/patch/10474799/
>>
>> I find it pointless to submit fixes for patches that weren't accepted
>> yet. Let's work on improving original patches while they are still
>> pending.
>
> I sent V4 with changes pointed our by Arend. That obsoletes all (?)
> monitor patches from this patchset. I believe it was cleaner to
> improve original patchset (not pushed yet).
>
> My suggestion is to apply patches 3/6 and 4/6 (they aren't monitor
> related) and drop the others.

Well. Given that Kalle prefers applying "all-or-nothing" I will resubmit 
the series addressing the issues you found.

Regards,
Arend
