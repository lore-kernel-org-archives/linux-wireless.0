Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:44754 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbeC3H03 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 03:26:29 -0400
Received: by mail-ot0-f195.google.com with SMTP id p33-v6so2528466otp.11
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2018 00:26:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5AB4C986.1090709@broadcom.com>
References: <1521734286-16293-1-git-send-email-dan.haab@luxul.com> <5AB4C986.1090709@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 30 Mar 2018 09:26:28 +0200
Message-ID: <CACna6rzfCA3VyiG2bCNY5eHRo9LGsvNa5Tmb23gyDeFBJHcQZg@mail.gmail.com> (sfid-20180330_092634_459821_ED03CD88)
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

On 23 March 2018 at 10:31, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 3/22/2018 4:58 PM, Dan Haab wrote:
>>
>> From: Dan Haab <dhaab@luxul.com>
>>
>> BCM4366E is a wireless chipset with a BCM43664 ChipCommon. It's
>> supported by the same firmware as 4366c0.
>
>
> Thanks, Dan
>
> I have a patch for that queued up already. So let me push that instead.

Arend: is there some actual problem with this patch? Other than you
have a similar one queued?

I'd prefer to just accept it as it's already there, it was sent first
and it looks alright. It hopefully won't be too hard to rebase your
queued work on top of this trivial patch.

--=20
Rafa=C5=82
