Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:53583 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752000AbeENJxD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 05:53:03 -0400
Subject: Re: brcmfmac: Updating Broadcom/Cypress Wifi/BT firmware
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kevin Hilman <khilman@baylibre.com>
References: <1350822038.83583.1525284334972@email.1und1.de>
 <5AF945B8.3070801@broadcom.com>
From: Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <944ad773-6a7a-17c5-1d7e-0a3d20173e1d@i2se.com> (sfid-20180514_115308_000870_6A243121)
Date: Mon, 14 May 2018 11:52:56 +0200
MIME-Version: 1.0
In-Reply-To: <5AF945B8.3070801@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Am 14.05.2018 um 10:15 schrieb Arend van Spriel:
> On 5/2/2018 8:05 PM, Stefan Wahren wrote:
>> Hi,
>> i wanted to know, if there are any plans to update the 
>> Broadcom/Cypress firmware under:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git 
>>
>>
>> As BCM2835 maintainer i'm interested in the following files:
>>
>> brcm/brcmfmac43430-sdio.bin
>> brcm/brcmfmac43455-sdio.bin
>
> To my knowledge (just checked ;-) ) these are already in the repository.

i know, but the subject was about updating. These files are from 
2015/2016 and contains a lot of issues (including CVE-2016-0801 
CVE-2017-0561 CVE-2017-9417).

AFAIK the latest version of brcmfmac43430-sdio.bin was from October 2017 
[1].

>
>> brcm/brcmfmac43430-sdio.txt
>
> We do not distribute these .txt files aka nvram files as they are 
> board specific and no good solution to express that in the filename.

Thanks for clarification

>
>> brcm/BCM43430A1.hcd
>
> The BT side is not handled by us. Might be different within Cypress 
> though.

Okay

>
> Regards,
> Arend

[1] - https://github.com/raspberrypi/linux/issues/1342

Best regards
Stefan
