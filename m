Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:34603 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935047Ab3DHSrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:47:05 -0400
Received: by mail-qa0-f43.google.com with SMTP id i13so990418qae.9
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 11:47:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5162E4E3.3040702@lwfinger.net>
References: <CACaajQsp-UFjn4odRWZMdjrijhhqcO1Y6F9m5QrJMBzvZjgtVA@mail.gmail.com>
 <5162E4E3.3040702@lwfinger.net>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Mon, 8 Apr 2013 22:46:48 +0400
Message-ID: <CACaajQsBNxMsac85fJ_3hDW_f9W1vePRY5S=O1ykX2+ekWs+vg@mail.gmail.com> (sfid-20130408_204712_480975_634481F8)
Subject: Re: bcm43228 support
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/8 Larry Finger <Larry.Finger@lwfinger.net>:
> According to
> http://wireless.kernel.org/en/users/Drivers/b43#Supported_devices, the only
> driver that supports the BCM43228 is the closed-source wl. If your device
> has PCI ID 14e4:4359, then neither brcmsmac nor b43 support it.
>
> The number of devices supported by b43 is limited by the time that we have
> to reverse engineer devices, and a need for an open-source driver. Your
> device is not widely distributed. The Broadcom people will need to say why
> they choose not to implement this device.
>
> If you need a wireless adapter for use with a Live CD, I suggest one of the
> popular USB devices.


I'm already read this link, but may be info is outdated and opensource
drivers for 43228 is available. Now broadcom-sta wl river works very
bad on my acer aspire v5.

--
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
