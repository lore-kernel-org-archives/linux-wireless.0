Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45699 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab1DKJMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 05:12:54 -0400
Received: by qyg14 with SMTP id 14so3774076qyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 02:12:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DA2702B.2080305@lwfinger.net>
References: <4DA2042A.3010301@gmail.com>
	<1302469406.5282.341.camel@localhost>
	<4DA22545.6050209@gmail.com>
	<4DA2312B.8080303@lwfinger.net>
	<4DA23594.8090002@gmail.com>
	<4DA2702B.2080305@lwfinger.net>
Date: Mon, 11 Apr 2011 11:12:53 +0200
Message-ID: <BANLkTimdBz9iSvjfkmbRS7FfgBT-Bzdk7Q@mail.gmail.com>
Subject: Re: Firmware for rt2800pci and rt2800usb
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 11, 2011 at 5:06 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Hi,
>
> I am in the process of updating the firmware files for rt2800pci and
> rt2800usb. If you have one of the devices that use this driver, please test
> the firmware file.
>

Cannot test these specific files right now, but Ralink does provide
firmware files
under these names that support all known devices supported by rt2800pci and
rt2800usb (if they are recent enough).
Back home I'm using slightly older versions of the firmware files on all devices
that I have (which does span RT2860 PCI, RT3090 PCIe, RT3562 PCI (driving not
working), RT2870, RT2070, RT3070, RT3071, RT3072, RT3370, RT3572 (driver not
working)).

Where did you get these specific files from?

I recommend using the ones that Ralink sent for inclusion in the since
these will
support even the newest devices (RT5370/RT5390).

---
Gertjan
