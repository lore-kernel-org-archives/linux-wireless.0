Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:2977 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371Ab0ECUnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 16:43:19 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 0/4] rt2x00: Assorted fixes and cleanups.
Date: Mon,  3 May 2010 22:43:01 +0200
Message-Id: <1272919385-18004-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a random set up fixes and cleanups for rt2x00.
All patches are against wireless-next-2.6.

The 3rd patch doesn't actually fix our HT40 issue for rt2800, but should
be a step in the right direction.

Gertjan van Wingerde (4):
  rt2x00: Remove rt2x00pci.h include from rt2800lib.
  rt2x00: Enable RT30xx by default.
  rt2x00: Fix HT40+/HT40- setting in rt2800.
  rt2x00: Register frame length in TX entry descriptor instead of L2PAD.

 drivers/net/wireless/rt2x00/Kconfig       |    4 ++--
 drivers/net/wireless/rt2x00/rt2400pci.c   |    4 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2800.h      |    4 ++--
 drivers/net/wireless/rt2x00/rt2800lib.c   |    7 ++-----
 drivers/net/wireless/rt2x00/rt2800pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++----
 drivers/net/wireless/rt2x00/rt2x00queue.h |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c     |    5 +++--
 drivers/net/wireless/rt2x00/rt73usb.c     |    2 +-
 12 files changed, 20 insertions(+), 24 deletions(-)

