Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:46293 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760355Ab3DHPkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 11:40:22 -0400
Received: by mail-ob0-f180.google.com with SMTP id un3so1662414obb.39
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 08:40:21 -0700 (PDT)
Message-ID: <5162E4E3.3040702@lwfinger.net> (sfid-20130408_174031_730429_4BEABE1C)
Date: Mon, 08 Apr 2013 10:40:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
CC: linux-wireless@vger.kernel.org
Subject: Re: bcm43228 support
References: <CACaajQsp-UFjn4odRWZMdjrijhhqcO1Y6F9m5QrJMBzvZjgtVA@mail.gmail.com>
In-Reply-To: <CACaajQsp-UFjn4odRWZMdjrijhhqcO1Y6F9m5QrJMBzvZjgtVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2013 08:10 AM, Vasiliy Tolstov wrote:
> Hello. I'm newbie in this list =).
> I'm search from google and mailing list  but can't fully understand:
> does bcma from wireless git tree support bcm43228?
> I don't like broadcom sta because it closed source (big blob) and
> require some steps to get works (manual download compile and so), that
> is not possible from live cd.
> Does it possible to get working wifi with opensource driver and
> connect to wpa-psk?

According to http://wireless.kernel.org/en/users/Drivers/b43#Supported_devices, 
the only driver that supports the BCM43228 is the closed-source wl. If your 
device has PCI ID 14e4:4359, then neither brcmsmac nor b43 support it.

The number of devices supported by b43 is limited by the time that we have to 
reverse engineer devices, and a need for an open-source driver. Your device is 
not widely distributed. The Broadcom people will need to say why they choose not 
to implement this device.

If you need a wireless adapter for use with a Live CD, I suggest one of the 
popular USB devices.

Larry




