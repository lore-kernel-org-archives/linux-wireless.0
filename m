Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:39600 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbbCLPdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 11:33:37 -0400
Received: by oigi138 with SMTP id i138so15048837oig.6
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 08:33:36 -0700 (PDT)
Message-ID: <5501B1CD.7080200@lwfinger.net> (sfid-20150312_163340_935822_85C92133)
Date: Thu, 12 Mar 2015 10:33:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	German <gentgerman@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iw dev wlp1s0 scan hangs
References: <20150311161757.dac357e24509141a4c98e84b@gmail.com>	<5500A4B6.4050702@broadcom.com>	<20150311163353.74922db84fc618b3b9039515@gmail.com>	<5500A93C.7060309@broadcom.com>	<20150311170018.c2581ec2ddfb4589f5c8b154@gmail.com>	<5500B0F2.3010804@broadcom.com> <20150311182146.bde39b79fad1e8cc61d6f4a0@gmail.com> <55014E36.5040707@broadcom.com>
In-Reply-To: <55014E36.5040707@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2015 03:28 AM, Arend van Spriel wrote:
> On 03/11/15 23:21, German wrote:
>> On Wed, 11 Mar 2015 22:17:38 +0100
>> Arend van Spriel<arend@broadcom.com>  wrote:
>>
>>> On 03/11/15 22:00, German wrote:
>>>> On Wed, 11 Mar 2015 21:44:44 +0100
>>>> Arend van Spriel<arend@broadcom.com>   wrote:
>>>>
>>>>> On 03/11/15 21:33, German wrote:
>>>>>> On Wed, 11 Mar 2015 21:25:26 +0100
>>>>>> Arend van Spriel<arend@broadcom.com>    wrote:
>>>>>>
>>>>>>> On 03/11/15 21:17, German wrote:
>>>>>>>> Hi. When I try to run aformentioned command it hangs for about 20 secs
>>>>>>>> and no output is returned. What's the problem might be? Thanks
>>>>>>>
>>>>>>> any more details you can share? What kernel version, what specific
>>>>>>> device is wlp1s0, do you have any kernel logging.
>>>>>>>
>>>>>
>>>>> When I wrote down the questions I was wondering how specifc I should be.
>>>>>> Kernel 3.18.7-gentoo.
>>>>>
>>>>> ok
>>>>>
>>>>>> wlp1s0 is my network card.
>>>>>
>>>>> Sure. I meant what brand and model.
>>>>>
>>>>> Can you run following commands:
>>>>> $ lspci
>>>>> $ lsusb
>>>>>
>>>> realtek RTL8723BE PCIe Wireless Network Adapter
>>>>
>>>>>> As for kernel logging, I simply don't know if I have it. Thanks
>>>>>
>>>>> Ok. Can you run following command after aborting the hanging iw scan
>>>>> command:
>>>>>
>>>>> $ dmesg
>>>>
>>>> Polling FW ready fail! Firmware is not ready to run.
>>>>
>>>> Ok, so I need some sort of firmware? That's what I thought. What is this and
>>>> where can I find it in kernel when I compile it? Thanks
>>>
>>> Not familiar with Realtek equipment but it might be provided by the
>>> linux-firmware package so:
>>>
>>> $ sudo emerge --ask linux-firmware
>>>
>>
>> Thanks Arend. This did the trick. I can now scan networks and I found mine.
>> But how I actually connect to my network? I guess it is encrypted, but I have
>> wpa_supplicant installed.
>
> Gentoo does not seem to provide NetworkManager as a solution. I found this page
> [1]. Maybe it helps.

Arend,

Thanks for handling this problem for a user with Realtek equipment. Apparently, 
this user does not know about "Reply-All", thus I only saw their answers to your 
questions in the material you quoted.

Larry


