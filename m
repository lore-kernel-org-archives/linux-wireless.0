Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:59993 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbZLVXDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:36 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH 0/5] Assorted rt2x00 cleanups and fixes.
Date: Wed, 23 Dec 2009 00:03:20 +0100
Message-Id: <1261523005-5856-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a patch series with some random clean ups and minor bug fixes.
The series is against the wireless-testing tree and nothing is in there
for 2.6.33.

Shortlog and diffstat are as follows:

Gertjan van Wingerde (5):
      rt2x00: Add USB ID for Linksys WUSB 600N rev 2.
      rt2x00: Fix checks for rt2800 SOC support.
      rt2x00: Let rt2800lib check CONFIG_RT2X00_LIB_USB instead of CONFIG_RT2800USB
      rt2x00: convert RT2800PCI_PCI and RT2800PCI_SOC Kconfig symbols to booleans.
      rt2x00: Cleanup chip handling helper functions.

 drivers/net/wireless/rt2x00/Kconfig     |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.c |    5 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |   39 ++++++-------
 drivers/net/wireless/rt2x00/rt2500usb.c |   38 ++++++-------
 drivers/net/wireless/rt2x00/rt2800lib.c |   94 +++++++++++++++----------------
 drivers/net/wireless/rt2x00/rt2800pci.c |   25 +++------
 drivers/net/wireless/rt2x00/rt2800usb.c |    5 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |   24 ++++----
 drivers/net/wireless/rt2x00/rt61pci.c   |   29 ++++------
 drivers/net/wireless/rt2x00/rt73usb.c   |   36 +++++-------
 10 files changed, 137 insertions(+), 162 deletions(-)

