Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45868 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1DJS0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 14:26:38 -0400
Received: by iyb14 with SMTP id 14so4949249iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 11:26:38 -0700 (PDT)
Message-ID: <4DA1F655.1070909@lwfinger.net>
Date: Sun, 10 Apr 2011 13:26:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: Firmware files for Ralink RT28x0
References: <4DA1E90A.5070902@gmail.com> <BANLkTimp6h9x0JC0HzSpKzdbKLOw=ioUvw@mail.gmail.com>
In-Reply-To: <BANLkTimp6h9x0JC0HzSpKzdbKLOw=ioUvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2011 12:35 PM, Ivo Van Doorn wrote:
> Hi.
>
>>> I notice that rt2800{pci,usb} each specify only one firmware image,
>>> regardless of the controller version.
>>>
>>> This is inconsistent with rt28{6,7}0sta and with the firmware images in
>>> linux-firmware.
>>>
>>> If you think that a single image per bus type can cover all controllers,
>>> please identify those firmware images, test them on each hardware
>>> generation, and get them into linux-firmware.
>>
>> querida:/datos/kernel/linux-2.6/drivers/net/wireless/rt2x00 $ grep "\.bin" *
>> rt2800pci.h:#define FIRMWARE_RT2860                     "rt2860.bin"
>> rt2800usb.h:#define FIRMWARE_RT2870                     "rt2870.bin"
>> rt61pci.h:#define FIRMWARE_RT2561                       "rt2561.bin"
>> rt61pci.h:#define FIRMWARE_RT2561s                      "rt2561s.bin"
>> rt61pci.h:#define FIRMWARE_RT2661                       "rt2661.bin"
>> rt73usb.h:#define FIRMWARE_RT2571                       "rt73.bin"
>>
>> rt3070.bin rt3071.bin rt3090.bin should be deleted from linux-firmware.
>> They were only need by staging drivers.
>
> True, but the rt2860 and rt2870 firmware file are outdated in the
> linux-firmware,
> and probably don't support the rt3090 or other more recent chipsets. So before
> they can be removed, those files must be updated.

As I wrote earlier, my RT3090 is supported by rt2860.bin. I haven't tested 
everything, but is functioned in STA and ad-hoc modes.

Larry
