Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48774 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752817AbdGUPkF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 11:40:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: gpio: Correct number of GPIOs for BCM53573
References: <20170630190257.15016-1-f.fainelli@gmail.com>
        <CACna6rwPRU7iGRxOym=LPpJu4_Lwr_cXTNduGyCnau9QKdhwPg@mail.gmail.com>
        <7481f7ab-6f09-a012-5609-cc803f316961@gmail.com>
Date: Fri, 21 Jul 2017 18:40:00 +0300
In-Reply-To: <7481f7ab-6f09-a012-5609-cc803f316961@gmail.com> (Florian
        Fainelli's message of "Tue, 18 Jul 2017 11:32:22 -0700")
Message-ID: <87fudp23zj.fsf@purkki.adurom.net> (sfid-20170721_174335_736041_5CAFAD1A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Florian Fainelli <f.fainelli@gmail.com> writes:

> On 06/30/2017 02:37 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
>> On 30 June 2017 at 21:02, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>> Broadcom BCM53573 SoCs actually have 32 GPIOs, and not 16.
>>>
>>> Fixes: 3f37ec79dd21 ("bcma: support BCM53573 series of wireless SoCs")
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>=20
>> Looks good.
>
> Is Kalle still on vacation, I suppose he is?

Started to play the catch up game with the inbox today :)

This is on my queue so I should be able to apply this soonish:

https://patchwork.kernel.org/patch/9820259/

--=20
Kalle Valo
