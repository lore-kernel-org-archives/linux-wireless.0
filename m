Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37630 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752500AbeEHMLl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 08:11:41 -0400
Received: by mail-wm0-f66.google.com with SMTP id l1-v6so21140881wmb.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2018 05:11:40 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Add support for bcm43364 wireless chipset
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Sean Lanigan <sean@lano.id.au>
References: <1525416503-832-1-git-send-email-sean@lano.id.au>
 <CAPDyKFr62-+EF_GRbUSa=VOQfYa3c3HHZCR_LsN67k1yVkNNFw@mail.gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Molton <ian@mnementh.co.uk>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AF193FA.7000700@broadcom.com> (sfid-20180508_141150_621282_300300C5)
Date: Tue, 8 May 2018 14:11:38 +0200
MIME-Version: 1.0
In-Reply-To: <CAPDyKFr62-+EF_GRbUSa=VOQfYa3c3HHZCR_LsN67k1yVkNNFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Kalle (explicitly)

On 5/8/2018 9:58 AM, Ulf Hansson wrote:
> On 4 May 2018 at 08:48, Sean Lanigan <sean@lano.id.au> wrote:
>> Add support for the BCM43364 chipset via an SDIO interface, as used in
>> e.g. the Murata 1FX module.
>>
>> The BCM43364 uses the same firmware as the BCM43430 (which is already
>> included), the only difference is the omission of Bluetooth.
>>
>> However, the SDIO_ID for the BCM43364 is 02D0:A9A4, giving it a MODALIAS
>> of sdio:c00v02D0dA9A4, which doesn't get recognised and hence doesn't
>> load the brcmfmac module. Adding the 'A9A4' ID in the appropriate place
>> triggers the brcmfmac driver to load, and then correctly use the
>> firmware file 'brcmfmac43430-sdio.bin'.
>>
>>
>> Signed-off-by: Sean Lanigan <sean@lano.id.au>
>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> Arend, I assume you want to pick this up? If not, just tell and I can do it.

Not necessarily. I let Kalle do the leg work ;-) Given the change I do 
not expect any conflict so we can go either way with a slight preference 
for wl-drivers-next. Kalle?

Regards,
Arend
