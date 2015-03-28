Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34494 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbC1BfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 21:35:00 -0400
Received: by wibg7 with SMTP id g7so50658028wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2015 18:34:59 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 28 Mar 2015 01:34:59 +0000
Message-ID: <CAJMB+NgPB9PwLPt1OdqRb7G-vRQ5u=uYjV8pk7OAHaJD9cUQPg@mail.gmail.com> (sfid-20150328_023513_169134_86B89A1D)
Subject: where to report linux-firmware needs newer Atheros bluetooth addition issues?
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a newish laptop (about 6 months old) - I started to need the bluetooth
hardware to work and noticed in 3.19.x dmesg, that

[   25.180483] usb 3-1.3: Direct firmware load for
ar3k/AthrBT_0x31010100.dfu failed with error -2
[   25.180501] Bluetooth: Patch file not found ar3k/AthrBT_0x31010100.dfu
[   25.180511] Bluetooth: Loading patch file failed
[   25.180534] ath3k: probe of 3-1.3:1.0 failed with error -2

It looks like linux-firmware only have AthrBT_0x31010000.dfu, and
haven't been updated for a while.

I searched a bit online and apparently the newer firmware can be have
from the Vista driver download from Microsoft. In fact two files are
needed, AthrBT_0x31010100.dfu
ramps_0x31010100_40.dfu . I extracted those, put them in /usr/lib/firmware/ar3k/
and the bluetooth hardware is then operational.

So where to report this to, and also, it would be nice if the Atheros
people can submit the newer firmwares to linux-firmware properly?

Hin-Tak
