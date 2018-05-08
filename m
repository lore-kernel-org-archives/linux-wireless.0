Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45834 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754527AbeEHMve (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 08:51:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Sean Lanigan <sean@lano.id.au>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Molton <ian@mnementh.co.uk>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: Add support for bcm43364 wireless chipset
References: <1525416503-832-1-git-send-email-sean@lano.id.au>
        <CAPDyKFr62-+EF_GRbUSa=VOQfYa3c3HHZCR_LsN67k1yVkNNFw@mail.gmail.com>
        <5AF193FA.7000700@broadcom.com>
Date: Tue, 08 May 2018 15:51:28 +0300
In-Reply-To: <5AF193FA.7000700@broadcom.com> (Arend van Spriel's message of
        "Tue, 8 May 2018 14:11:38 +0200")
Message-ID: <871semz4xb.fsf@kamboji.qca.qualcomm.com> (sfid-20180508_145139_154267_545AC50B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> + Kalle (explicitly)
>
> On 5/8/2018 9:58 AM, Ulf Hansson wrote:
>> On 4 May 2018 at 08:48, Sean Lanigan <sean@lano.id.au> wrote:
>>> Add support for the BCM43364 chipset via an SDIO interface, as used in
>>> e.g. the Murata 1FX module.
>>>
>>> The BCM43364 uses the same firmware as the BCM43430 (which is already
>>> included), the only difference is the omission of Bluetooth.
>>>
>>> However, the SDIO_ID for the BCM43364 is 02D0:A9A4, giving it a MODALIAS
>>> of sdio:c00v02D0dA9A4, which doesn't get recognised and hence doesn't
>>> load the brcmfmac module. Adding the 'A9A4' ID in the appropriate place
>>> triggers the brcmfmac driver to load, and then correctly use the
>>> firmware file 'brcmfmac43430-sdio.bin'.
>>>
>>>
>>> Signed-off-by: Sean Lanigan <sean@lano.id.au>
>>
>> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>>
>> Arend, I assume you want to pick this up? If not, just tell and I can do it.
>
> Not necessarily. I let Kalle do the leg work ;-) Given the change I do
> not expect any conflict so we can go either way with a slight
> preference for wl-drivers-next. Kalle?

Yeah, I would like to take this to wireless-drivers-next. Less conflicts
that way.

-- 
Kalle Valo
