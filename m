Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:32090 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbbCNTyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 15:54:04 -0400
Message-ID: <550491DA.6030105@broadcom.com> (sfid-20150314_205408_534931_D8C2A452)
Date: Sat, 14 Mar 2015 20:54:02 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Ochal Christophe <christophe.ochal@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
References: <550482A2.3080803@gmail.com> <55048833.90408@broadcom.com> <55048BB1.9080906@gmail.com>
In-Reply-To: <55048BB1.9080906@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

On 03/14/15 20:27, Ochal Christophe wrote:
> Dear Sir,
>
> On 03/14/2015 08:12 PM, Arend van Spriel wrote:
>> The nvram file is board specific and so Asus should be able to provide
>> that. What OS does Asus provide on this eee book? The firmware file
>> will be submitted to linux-firmware soon, but in the mean time you can
>> also find it in Android repository [1]. Just rename the file
>> fw_43341.bin to brcmfmac43340-sdio.bin.
>>
>> Regards,
>> Arend
>>
>> [1]
>> https://android.googlesource.com/platform/hardware/broadcom/wlan/+/master/bcmdhd/firmware/bcm43341/
>>
>
> Thank you for the link, the Asus eebook x205ta comes with Windows 8.1,
> no idea how I'm going to get Asus to deliver that nvram, but at least
> I'm halfway there now, the firmware loads correctly.

For Windows 8.1 the nvram file is stored in EFI variable space. This is 
accessible in Linux as well. If I recall correctly it should be in 
/sys/firmware/efi/efivars. There should be a file named nvram-*. Copy 
that to /lib/firmware/brcm/brcmfmac43340-sdio.txt.

Regards,
Arend

