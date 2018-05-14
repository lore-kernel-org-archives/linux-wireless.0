Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:15222 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753059AbeENL4h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 07:56:37 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w4EBtniL015033
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 12:56:35 +0100
Received: from mail-wr0-f200.google.com (mail-wr0-f200.google.com [209.85.128.200])
        by mx07-00252a01.pphosted.com with ESMTP id 2hwnp0s196-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 12:56:35 +0100
Received: by mail-wr0-f200.google.com with SMTP id 54-v6so9455071wrw.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 04:56:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <944ad773-6a7a-17c5-1d7e-0a3d20173e1d@i2se.com>
References: <1350822038.83583.1525284334972@email.1und1.de>
 <5AF945B8.3070801@broadcom.com> <944ad773-6a7a-17c5-1d7e-0a3d20173e1d@i2se.com>
From: James Hughes <james.hughes@raspberrypi.org>
Date: Mon, 14 May 2018 12:56:33 +0100
Message-ID: <CAE_XsMK_CeDgvq6DXVyJyTu_o9QAEDzdYB0vTkd6ZT-NdzBLZA@mail.gmail.com> (sfid-20180514_135642_616353_23FEC7B4)
Subject: Re: brcmfmac: Updating Broadcom/Cypress Wifi/BT firmware
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kevin Hilman <khilman@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 May 2018 at 10:52, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> Hi Arend,
>
> Am 14.05.2018 um 10:15 schrieb Arend van Spriel:
>>
>> On 5/2/2018 8:05 PM, Stefan Wahren wrote:
>>>
>>> Hi,
>>> i wanted to know, if there are any plans to update the Broadcom/Cypress
>>> firmware under:
>>>
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>>>
>>> As BCM2835 maintainer i'm interested in the following files:
>>>
>>> brcm/brcmfmac43430-sdio.bin
>>> brcm/brcmfmac43455-sdio.bin
>>
>>
>> To my knowledge (just checked ;-) ) these are already in the repository.
>
>
> i know, but the subject was about updating. These files are from 2015/2016
> and contains a lot of issues (including CVE-2016-0801 CVE-2017-0561
> CVE-2017-9417).
>
> AFAIK the latest version of brcmfmac43430-sdio.bin was from October 2017
> [1].
>
>>
>>> brcm/brcmfmac43430-sdio.txt
>>
>>
>> We do not distribute these .txt files aka nvram files as they are board
>> specific and no good solution to express that in the filename.
>
>
> Thanks for clarification
>
>>
>>> brcm/BCM43430A1.hcd
>>
>>
>> The BT side is not handled by us. Might be different within Cypress
>> though.
>
>
> Okay
>
>>
>> Regards,
>> Arend
>
>
> [1] - https://github.com/raspberrypi/linux/issues/1342
>
> Best regards
> Stefan


Just an an indicator, the Raspberry Pi supplied firmware, which I
believe is now a standard build (no customisations) from the Cypress
firmware source tree, is dated Oct 2017, so somewhat newer than that
in firmware. It also has a some bug fixes in, Stefan has flagged
some of the security ones, but there are others.
