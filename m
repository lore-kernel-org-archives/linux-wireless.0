Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35060 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab1DVWAm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 18:00:42 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2011 15:00:15 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <dwmw2@infradead.org>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<greg@kroah.com>, <vmehta@atheros.com>, <nsingh@atheros.com>,
	<kvalo@atheros.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] linux-firmware: changes for ath6kl firmware
Date: Fri, 22 Apr 2011 15:00:37 -0700
Message-ID: <1303509639-32448-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David,

the first patch was sent September, 1, 2010 but I just noticed that it was
never applied. I am resending that and now with the never-sent-before ath6kl
firmware...

Luis R. Rodriguez (2):
  linux-firmware: update Atheros firmware license
  linux-firmware: add ath6kl firmware

 LICENCE.atheros_firmware              |    4 +--
 WHENCE                                |   38 +++++++++++++++++++++++++++++++++
 ath6k/AR6002/athwlan.bin.z77          |  Bin 0 -> 98425 bytes
 ath6k/AR6002/data.patch.hw2_0.bin     |  Bin 0 -> 1336 bytes
 ath6k/AR6002/eeprom.bin               |  Bin 0 -> 784 bytes
 ath6k/AR6002/eeprom.data              |  Bin 0 -> 48 bytes
 ath6k/AR6003/hw1.0/athwlan.bin.z77    |  Bin 0 -> 122209 bytes
 ath6k/AR6003/hw1.0/bdata.SD31.bin     |  Bin 0 -> 1024 bytes
 ath6k/AR6003/hw1.0/bdata.SD32.bin     |  Bin 0 -> 1024 bytes
 ath6k/AR6003/hw1.0/bdata.WB31.bin     |  Bin 0 -> 1024 bytes
 ath6k/AR6003/hw1.0/data.patch.bin     |  Bin 0 -> 5524 bytes
 ath6k/AR6003/hw1.0/otp.bin.z77        |  Bin 0 -> 1665 bytes
 ath6k/AR6003/hw2.0/athwlan.bin.z77    |  Bin 0 -> 100694 bytes
 ath6k/AR6003/hw2.0/bdata.SD31.bin     |  Bin 0 -> 1792 bytes
 ath6k/AR6003/hw2.0/bdata.SD32.bin     |  Bin 0 -> 1792 bytes
 ath6k/AR6003/hw2.0/bdata.WB31.bin     |  Bin 0 -> 1792 bytes
 ath6k/AR6003/hw2.0/data.patch.bin     |  Bin 0 -> 6012 bytes
 ath6k/AR6003/hw2.0/otp.bin.z77        |  Bin 0 -> 3689 bytes
 ath6k/AR6003/hw2.1.1/athwlan.bin      |  Bin 0 -> 68975 bytes
 ath6k/AR6003/hw2.1.1/bdata.SD31.bin   |  Bin 0 -> 1792 bytes
 ath6k/AR6003/hw2.1.1/bdata.SD32.bin   |  Bin 0 -> 1792 bytes
 ath6k/AR6003/hw2.1.1/bdata.WB31.bin   |  Bin 0 -> 1792 bytes
 ath6k/AR6003/hw2.1.1/data.patch.bin   |  Bin 0 -> 140 bytes
 ath6k/AR6003/hw2.1.1/endpointping.bin |  Bin 0 -> 12810 bytes
 ath6k/AR6003/hw2.1.1/otp.bin          |  Bin 0 -> 2783 bytes
 25 files changed, 39 insertions(+), 3 deletions(-)
 create mode 100755 ath6k/AR6002/athwlan.bin.z77
 create mode 100755 ath6k/AR6002/data.patch.hw2_0.bin
 create mode 100755 ath6k/AR6002/eeprom.bin
 create mode 100755 ath6k/AR6002/eeprom.data
 create mode 100644 ath6k/AR6003/hw1.0/athwlan.bin.z77
 create mode 100644 ath6k/AR6003/hw1.0/bdata.SD31.bin
 create mode 100644 ath6k/AR6003/hw1.0/bdata.SD32.bin
 create mode 100644 ath6k/AR6003/hw1.0/bdata.WB31.bin
 create mode 100644 ath6k/AR6003/hw1.0/data.patch.bin
 create mode 100644 ath6k/AR6003/hw1.0/otp.bin.z77
 create mode 100644 ath6k/AR6003/hw2.0/athwlan.bin.z77
 create mode 100644 ath6k/AR6003/hw2.0/bdata.SD31.bin
 create mode 100644 ath6k/AR6003/hw2.0/bdata.SD32.bin
 create mode 100644 ath6k/AR6003/hw2.0/bdata.WB31.bin
 create mode 100644 ath6k/AR6003/hw2.0/data.patch.bin
 create mode 100644 ath6k/AR6003/hw2.0/otp.bin.z77
 create mode 100644 ath6k/AR6003/hw2.1.1/athwlan.bin
 create mode 100644 ath6k/AR6003/hw2.1.1/bdata.SD31.bin
 create mode 100644 ath6k/AR6003/hw2.1.1/bdata.SD32.bin
 create mode 100644 ath6k/AR6003/hw2.1.1/bdata.WB31.bin
 create mode 100644 ath6k/AR6003/hw2.1.1/data.patch.bin
 create mode 100644 ath6k/AR6003/hw2.1.1/endpointping.bin
 create mode 100644 ath6k/AR6003/hw2.1.1/otp.bin

-- 
1.7.4.15.g7811d

