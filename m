Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:53400 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860AbZBPQUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 11:20:54 -0500
Message-ID: <49999255.5070302@lwfinger.net> (sfid-20090216_172101_842691_B618D7B0)
Date: Mon, 16 Feb 2009 10:20:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?VmlrdG9yIElsaWphxaFpxIc=?= <viktor.ilijasic@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 not handling my usb card
References: <63d38a500902152114o7b3c0f91j571a1e1d62e31d24@mail.gmail.com> <63d38a500902152133y264b783cl76800ed3efa46dd4@mail.gmail.com>
In-Reply-To: <63d38a500902152133y264b783cl76800ed3efa46dd4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Viktor Ilija=C5=A1i=C4=87 wrote:
>=20
> If any more info is needed, please, feel free to ask.
>=20
> $ tail /var/log/syslog
> Feb 16 05:55:36 CH4 kernel: [ 1389.137978] usbcore: deregistering
> interface driver rtl8187
> Feb 16 05:55:41 CH4 kernel: [ 1394.294357] usbcore: registered new
> interface driver rtl8187
> Feb 16 05:55:45 CH4 kernel: [ 1397.480159] usb 4-3: new high speed US=
B
> device using ehci_hcd and address 4
> Feb 16 05:55:45 CH4 kernel: [ 1397.678395] usb 4-3: configuration #1
> chosen from 1 choice
>=20
> $ lsusb
> Bus 004 Device 004: ID 1b75:8187
> Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

The driver for USB devices is selected from the ID's, just as it is wit=
h PCI
devices.

Please send the details for your device as output from the 'lsusb -v' c=
ommand. I
don't need the data for any other USB stuff, just the 8187. Once I have=
 that
info, I will send you a test patch for your sources.

Larry

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
