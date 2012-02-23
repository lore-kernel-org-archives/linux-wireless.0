Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1478 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab2BWVUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 16:20:35 -0500
Message-ID: <4F46AD93.6010508@broadcom.com> (sfid-20120223_222039_521602_92F2C188)
Date: Thu, 23 Feb 2012 22:20:19 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"M. Lambert" <lambertm@westman.wave.ca>
Subject: Re: [PATCH 14/15] brcm80211: fmac: add USB support for
 bcm43235/6/8 chipsets
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
 <1328818149-4826-15-git-send-email-arend@broadcom.com>
 <CACna6rxgGuCNY19Dn=VcgUH=EORNr72x4CTbR61srSZmcM+h-w@mail.gmail.com>
 <CACna6rxSrzuEHTC++kZj79sQ7JEv42ckHj5o4bZ5bCULWKUXqA@mail.gmail.com>
In-Reply-To: <CACna6rxSrzuEHTC++kZj79sQ7JEv42ckHj5o4bZ5bCULWKUXqA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2012 07:46 PM, Rafał Miłecki wrote:
> W dniu 23 lutego 2012 19:10 użytkownik Rafał Miłecki<zajec5@gmail.com>  napisał:
>> 2012/2/9 Arend van Spriel<arend@broadcom.com>:
>>> This patch extends the use of the brcmfmac driver with support for
>>> chipsets with a USB host interface. The first chipsets supported are
>>> the bcm43235, bcm43236, and bcm43238 for which firmware has been
>>> submitted.
>>
>> Can you say something more about the firmware? AFAICS brcm directory
>> in linux-firmware.git contains:
>> brcmfmac43236b.bin
>> brcmfmac4329.bin
>> brcmfmac4330.bin
>>
>>
>>> +#define BRCMF_USB_FW_NAME      "brcm/brcmfmac-usb.bin"
>>
>> However your driver seems to require *only* brcmfmac-usb.bin firmware file...
>
> The only file passing usb.c::check_file test seems to be
> brcmfmac43236b.bin. I guess you meant this file name in usb.c.
>

Yes. bcm4329 and bcm4330 are SDIO cards. I will update the information 
on linuxwireless.

Gr. AvS

