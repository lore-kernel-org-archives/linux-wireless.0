Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:41458 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751771AbeCWJ24 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 05:28:56 -0400
Received: by mail-qt0-f177.google.com with SMTP id j4so11854697qth.8
        for <linux-wireless@vger.kernel.org>; Fri, 23 Mar 2018 02:28:56 -0700 (PDT)
Subject: Re: AP6335 with mainline kernel
To: Vanessa Maegima <vanessa.maegima@nxp.com>,
        "festevam@gmail.com" <festevam@gmail.com>
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <85717463-11e2-e2e3-b08e-b758986687b5@broadcom.com>
 <1510916848.26896.2.camel@nxp.com> <5A0EDC25.7030505@broadcom.com>
 <1510932224.22506.0.camel@nxp.com>
 <d9a80a75-b3d4-d78e-a5bf-ab31732f040d@broadcom.com>
 <e14bdc26-5092-18c9-4caa-c45fd1d12984@broadcom.com>
 <1511347672.18886.2.camel@nxp.com> <5A15584A.9090601@broadcom.com>
 <1511450638.9102.1.camel@nxp.com> <5A1FFA17.6000703@broadcom.com>
 <1512413992.18900.3.camel@nxp.com>
 <CAF7Mx6q6mTOXc=4OFVCHAHd26pyfv5e6pK=TMNmb1S6=FBWUWQ@mail.gmail.com>
 <1512485878.9392.1.camel@nxp.com>
 <CAOMZO5DXoCFgTtuRRAq_jFjzkzFp6chMCwczXF5Z0bFaNfQnog@mail.gmail.com>
 <5A5E5EBE.7040301@broadcom.com> <1516276016.8817.1.camel@nxp.com>
 <5A61B43C.4000305@broadcom.com> <1521646672.13983.1.camel@nxp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "van.ayumi@gmail.com" <van.ayumi@gmail.com>,
        "embed3d@gmail.com" <embed3d@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AB4C8D5.40203@broadcom.com> (sfid-20180323_102900_939335_771FE68A)
Date: Fri, 23 Mar 2018 10:28:53 +0100
MIME-Version: 1.0
In-Reply-To: <1521646672.13983.1.camel@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/21/2018 4:38 PM, Vanessa Maegima wrote:
> Hi Arend,
>
> On Sex, 2018-01-19 at 10:02 +0100, Arend van Spriel wrote:
>> On 1/18/2018 12:47 PM, Vanessa Maegima wrote:
>>>
>>> Hi Arend,
>>>
>>> On Ter, 2018-01-16 at 21:21 +0100, Arend van Spriel wrote:
>>>>
>>>> On 1/15/2018 9:08 PM, Fabio Estevam wrote:
>>>>>
>>>>>
>>>>> Hi Arend,
>>>>>
>>>>> On Tue, Dec 5, 2017 at 12:58 PM, Vanessa Maegima
>>>>> <vanessa.maegima@nxp.com> wrote:
>>>>>
>>>>>>
>>>>>>
>>>>>> Hi Arend,
>>>>>>
>>>>>> Sorry for this!
>>>>>>
>>>>>> I updated the folder on https://emea01.safelinks.protection.o
>>>>>> utlook.com/?url=https%3A%2F%2Femea01.safelinks.protection.out
>>>>>> lo&data=02%7C01%7Cvanessa.maegima%40nxp.com%7C39040229475441d
>>>>>> 7b5aa08d55f1b6cd3%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C1%
>>>>>> 7C636519493755298348&sdata=Zws4AElm4La96Q4pjK152nH2lP6v4mPJJN
>>>>>> xSGz7TLBA%3D&reserved=0
>>>>>> ok.com/?url=https%3A%2F%2Fdrive.google.com%2Fdrive%2Ffolders%
>>>>>> 2F1f
>>>>>> osahjL&data=02%7C01%7Cvanessa.maegima%40nxp.com%7Cf07cd1a6ffb
>>>>>> 34c0
>>>>>> 961f608d55d1eb901%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%
>>>>>> 7C63
>>>>>> 6517308901643244&sdata=6JAqSN%2BVPJ%2FCF7cbnBjm8geMKWydWkG9Jc
>>>>>> UhGB
>>>>>> Pj644%3D&reserved=0
>>>>>> N1KI5NKS59_aPZdHLpENPFHtK
>>>>>>
>>>>>> Thanks!
>>>>> Any ideas, please?
>>>> Well, the dumps confirm a crash early in the firmware boot.
>>>> However,
>>>> I
>>>> could not obtain more information from it. To capture the failure
>>>> I
>>>> need
>>>> to rework some firmware functionality which is not trivial and I
>>>> can
>>>> not
>>>> claim time for it right now.
>>>>
>>>> Regards,
>>>> Arend
>>>>
>>> Thanks for all your investigation here!
>>>
>>> I just want to report one more thing that I noticed from my tests.
>>>
>>> I have tried to use an html file that I downloaded using wget as
>>> the
>>> nvram file (https://emea01.safelinks.protection.outlook.com/?url=ht
>>> tps%3A%2F%2Fgithub.com%2FOpenELEC%2Fwlan-
>>> firmware%2Fblob%2Fmaster%2Ffirmw&data=02%7C01%7Cvanessa.maegima%40n
>>> xp.com%7C39040229475441d7b5aa08d55f1b6cd3%7C686ea1d3bc2b4c6fa92cd99
>>> c5c301635%7C0%7C1%7C636519493755298348&sdata=EZFVV3qbStjH9Eqe6uVVXJ
>>> f7LmQlMLIURXHaQIMIpms%3D&reserved=0
>>> are/brcm/nvram_ap6335.txt) and the wifi seems to work. I have not
>>> noticed the wrong format file until testing it.
>> Interesting. In brcmfmac the file is parsed before sending it to the
>> firmware so I am wondering what is effectively send to the device.
>>
>> Can you dump the nvram that is sent to the device. Just add hexdump
>> call
>> of nvram in brcmf_fw_request_nvram_done() in firmware.c just before
>> fwctx->done() is called.
>>
>> Regards,
>> Arend
>
> Sorry for my delayed response, but I could not get the hexdump from the
> nvram. I have tried several hexdump functions I found on kernel and on
> the brcmfmac driver but none of them printed any output.
>
> Is there any CONFIG I need to enable to get those working?

CONFIG_BRCMDBG should be enabled. Or just add '#define DEBUG' in 
firmware.c before the include statements.

Regards,
Arend
