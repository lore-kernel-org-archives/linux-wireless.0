Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765478AbXGaSeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:19 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:18 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/24] rt2x00: Lindent
Date: Tue, 31 Jul 2007 20:37:27 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.27668.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 2d772e1724a2e7480133ed80f8bf6e6ac3c609e8 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 28 Jul 2007 21:47:48 +0200
Subject: [PATCH 15/24] rt2x00: Lindent

Run Lindent to make the code conform Kernel Coding Style.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c      |  231 +++++++-------
 drivers/net/wireless/rt2400pci.h      |    1 -
 drivers/net/wireless/rt2500pci.c      |  238 +++++++-------
 drivers/net/wireless/rt2500usb.c      |  237 ++++++++-------
 drivers/net/wireless/rt2x00.h         |  135 +++++----
 drivers/net/wireless/rt2x00debug.c    |   24 +-
 drivers/net/wireless/rt2x00debug.h    |    8 +-
 drivers/net/wireless/rt2x00dev.c      |  107 ++++---
 drivers/net/wireless/rt2x00dev.h      |    5 +-
 drivers/net/wireless/rt2x00firmware.c |    8 +-
 drivers/net/wireless/rt2x00lib.h      |   26 +-
 drivers/net/wireless/rt2x00mac.c      |   66 ++--
 drivers/net/wireless/rt2x00pci.c      |   51 ++--
 drivers/net/wireless/rt2x00pci.h      |   26 +-
 drivers/net/wireless/rt2x00rfkill.c   |    2 +-
 drivers/net/wireless/rt2x00rfkill.h   |    8 +-
 drivers/net/wireless/rt2x00usb.c      |  129 ++++-----
 drivers/net/wireless/rt2x00usb.h      |   13 +-
 drivers/net/wireless/rt61pci.c        |  558 +++++++++++++++++----------------
 drivers/net/wireless/rt61pci.h        |    1 -
 drivers/net/wireless/rt73usb.c        |  420 +++++++++++++------------
 drivers/net/wireless/rt73usb.h        |    1 -
 22 files changed, 1188 insertions(+), 1107 deletions(-)

---

http://mendiosus.nl/rt2x00/0015-rt2x00-Lindent.patch
