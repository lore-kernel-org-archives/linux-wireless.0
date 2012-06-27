Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:40389 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756310Ab2F0UxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 16:53:18 -0400
Message-ID: <43a66e0f20b45e9cc461272e83f2c4e4.squirrel@www.infidigm.net> (sfid-20120627_225322_729703_48DA7344)
Date: Wed, 27 Jun 2012 17:28:55 -0400
Subject: ar6004 / ar9374 firmware
From: drwho@infidigm.net
To: "Kalle Valo" <kvalo@qca.qualcomm.com>
Cc: "Julian Calaby" <julian.calaby@gmail.com>,
	"Sujith Manoharan" <c_manoha@qca.qualcomm.com>,
	"Mohammed Shafi" <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle,

I've noticed in core.h in the ath6kl driver that it is defining the
following firmware for the ar6004....

ath6k/AR6004/hw1.0/fw.ram.bin
ath6k/AR6004/hw1.1/fw.ram.bin
ath6k/AR6004/hw1.2/fw.ram.bin

In linux-firmware.git all that exists is...

ath6k/AR6004/hw1.2/fw-2.bin
ath6k/AR6004/hw1.2/bdata.bin

fw-2.bin need a rename?

Also, my UB134 is coming up with a device ID of 0x31c8088a?

[  361.676440] ath6kl: Unsupported hardware version: 0x31c8088a
[  361.680437] ath6kl: Failed to init ath6kl core: -22
[  361.680491] ath6kl_usb: probe of 2-1:1.0 failed with error -22
[  361.680520] usbcore: registered new interface driver ath6kl_usb

Jon

> That's right, AR9374 is basically AR6004 with USB. Don't ask me why :)
Latest ath6kl should support is. I can't remember what kernel version
has the full support, but I'm pretty sure 3.3 didn't support it yet. But
I should update ath6kl documentation to mention this, thanks for
pointing this out.
> Kalle




