Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56362 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab2BXGQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 01:16:39 -0500
Received: by werb13 with SMTP id b13so1216160wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 22:16:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F46AD93.6010508@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
	<1328818149-4826-15-git-send-email-arend@broadcom.com>
	<CACna6rxgGuCNY19Dn=VcgUH=EORNr72x4CTbR61srSZmcM+h-w@mail.gmail.com>
	<CACna6rxSrzuEHTC++kZj79sQ7JEv42ckHj5o4bZ5bCULWKUXqA@mail.gmail.com>
	<4F46AD93.6010508@broadcom.com>
Date: Fri, 24 Feb 2012 07:16:37 +0100
Message-ID: <CACna6rw9jU0HOOVHKNzqMW8sRXFgOwbSw6iOri4oQ_uTVopafw@mail.gmail.com> (sfid-20120224_071642_458555_1EB590F8)
Subject: Re: [PATCH 14/15] brcm80211: fmac: add USB support for bcm43235/6/8 chipsets
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"M. Lambert" <lambertm@westman.wave.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 23 lutego 2012 22:20 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 02/23/2012 07:46 PM, Rafał Miłecki wrote:
>>
>> W dniu 23 lutego 2012 19:10 użytkownik Rafał Miłecki<zajec5@gmail.com>
>>  napisał:
>>>
>>> 2012/2/9 Arend van Spriel<arend@broadcom.com>:
>>>>
>>>> This patch extends the use of the brcmfmac driver with support for
>>>> chipsets with a USB host interface. The first chipsets supported are
>>>> the bcm43235, bcm43236, and bcm43238 for which firmware has been
>>>> submitted.
>>>
>>>
>>> Can you say something more about the firmware? AFAICS brcm directory
>>> in linux-firmware.git contains:
>>> brcmfmac43236b.bin
>>> brcmfmac4329.bin
>>> brcmfmac4330.bin
>>>
>>>
>>>> +#define BRCMF_USB_FW_NAME      "brcm/brcmfmac-usb.bin"
>>>
>>>
>>> However your driver seems to require *only* brcmfmac-usb.bin firmware
>>> file...
>>
>>
>> The only file passing usb.c::check_file test seems to be
>> brcmfmac43236b.bin. I guess you meant this file name in usb.c.
>>
>
> Yes. bcm4329 and bcm4330 are SDIO cards. I will update the information on
> linuxwireless.

I'm afraid we don't understand each other. The problem is that
filename of firmware submitted to the linux-firmware.git doesn't match
filename requested by brcmfmac/usb.c.

brcmfmac43236b.bin != brcmfmac-usb.bin

-- 
Rafał
