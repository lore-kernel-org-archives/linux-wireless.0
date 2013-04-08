Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51503 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762581Ab3DHUsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 16:48:19 -0400
Received: by mail-ob0-f173.google.com with SMTP id wn14so5313176obc.32
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 13:48:18 -0700 (PDT)
Message-ID: <51632D10.8010401@lwfinger.net> (sfid-20130408_224823_472604_C2AF8D2A)
Date: Mon, 08 Apr 2013 15:48:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
CC: linux-wireless@vger.kernel.org
Subject: Re: bcm43228 support
References: <CACaajQsp-UFjn4odRWZMdjrijhhqcO1Y6F9m5QrJMBzvZjgtVA@mail.gmail.com> <5162E4E3.3040702@lwfinger.net> <CACaajQsBNxMsac85fJ_3hDW_f9W1vePRY5S=O1ykX2+ekWs+vg@mail.gmail.com>
In-Reply-To: <CACaajQsBNxMsac85fJ_3hDW_f9W1vePRY5S=O1ykX2+ekWs+vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2013 01:46 PM, Vasiliy Tolstov wrote:
> 2013/4/8 Larry Finger <Larry.Finger@lwfinger.net>:
>> According to
>> http://wireless.kernel.org/en/users/Drivers/b43#Supported_devices, the only
>> driver that supports the BCM43228 is the closed-source wl. If your device
>> has PCI ID 14e4:4359, then neither brcmsmac nor b43 support it.
>>
>> The number of devices supported by b43 is limited by the time that we have
>> to reverse engineer devices, and a need for an open-source driver. Your
>> device is not widely distributed. The Broadcom people will need to say why
>> they choose not to implement this device.
>>
>> If you need a wireless adapter for use with a Live CD, I suggest one of the
>> popular USB devices.
>
>
> I'm already read this link, but may be info is outdated and opensource
> drivers for 43228 is available. Now broadcom-sta wl river works very
> bad on my acer aspire v5.

The only way to know is to search the kernel source for the appropriate PCI ID. 
As you did not provide that for your device, I had to guess. I might have done 
that incorrectly, but if I tried the correct one, the current wireless-testing 
does not support your device.

Sorry about faulty operation of wl, but there is nothing we can do about that.

Larry


