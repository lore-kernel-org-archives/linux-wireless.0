Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:60068 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475Ab0C3Vuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 17:50:35 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, <users@rt2x00.serialmonkey.com>,
	<linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/4] rt2x00: Powersave fixes.
Date: Tue, 30 Mar 2010 23:50:22 +0200
Message-Id: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following 4 patches fix powersave behavior of rt2x00.
The first patch fixes the rt2500usb powersave issues found lately.
The second on enables powersave for rt2500usb again, now it is fixed.
The third and fourth are ongoing work to bring the other PCI drivers
in a better shape.

All patches are against wireless-2.6.

The patch series is also available via:

	git://git.gwingerde.nl/rt2x00-2.6.git

Gertjan van Wingerde (4):
  rt2x00: Disable auto wakeup before waking up device.
  rt2x00: Enable powersaving by default again on rt2500usb.
  rt2x00: Add wakeup interrupt handler to rt61pci.
  rt2x00: Add wakeup interrupt handler to rt2800pci.

 drivers/net/wireless/rt2x00/rt2400pci.c |    4 ++++
 drivers/net/wireless/rt2x00/rt2500pci.c |    4 ++++
 drivers/net/wireless/rt2x00/rt2500usb.c |    9 ++++-----
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2800pci.c |   11 +++++++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |   14 ++++++++++++++
 drivers/net/wireless/rt2x00/rt73usb.c   |    6 +++---
 7 files changed, 42 insertions(+), 10 deletions(-)

