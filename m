Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34235 "EHLO
        mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753655AbcHXTW7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Aug 2016 15:22:59 -0400
Received: by mail-pa0-f48.google.com with SMTP id fi15so9153420pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2016 12:22:59 -0700 (PDT)
Subject: Re: brcmfmac43430-sdio.bin in linux-firmware
To: Fabio Estevam <festevam@gmail.com>
References: <CAOMZO5BVB4YTsdzhU2f7jKZop6i1QaGGT2YM3Yw3DbYxeJ-v5w@mail.gmail.com>
 <CAOMZO5C-NTppSiZt_Pc5GLrta06zvZiBwTVmpzhLVOR3f-6VbA@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e9fde75d-a17a-8a3e-feee-6495eec0f67f@broadcom.com> (sfid-20160824_212302_937014_A8F7671D)
Date: Wed, 24 Aug 2016 21:22:51 +0200
MIME-Version: 1.0
In-Reply-To: <CAOMZO5C-NTppSiZt_Pc5GLrta06zvZiBwTVmpzhLVOR3f-6VbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 24-8-2016 21:13, Fabio Estevam wrote:
> Hi Arend,
> 
> On Sat, Aug 6, 2016 at 12:15 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> Hi,
>>
>> I managed to get Wifi working on a imx7 warp board, which has a BCM43430 device.
>>
>> I used the firmware from the RaspberryPi repository:
>> https://github.com/RPi-Distro/firmware-nonfree/tree/master/brcm80211/brcm
>>
>> Are there any plans to make brcmfmac43430-sdio.bin available in the
>> official linux-firmware repository?
> 
> Is this something you could help?

I could, but this is handled by Cypress now. I have asked for firmware
release tag so I can release it.

Regards,
Arend
