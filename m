Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45896 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2GNSqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jul 2012 14:46:51 -0400
Received: by weyx8 with SMTP id x8so3159774wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jul 2012 11:46:50 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: xose.vazquez@gmail.com, dwmw2@infradead.org, ben@decadent.org.uk
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] linux-firmware: add carl9170 firmware
Date: Sat, 14 Jul 2012 20:46:46 +0200
Message-Id: <1342291606-11596-1-git-send-email-xose.vazquez@gmail.com> (sfid-20120714_204654_810101_ADFB49A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GPLv2 firmware for carl9170, Atheros AR9170 802.11 draft-n USB driver.

Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 WHENCE        |   11 +++++++++++
 carl9170-1.fw |  Bin 0 -> 13388 bytes
 2 files changed, 11 insertions(+)
 create mode 100644 carl9170-1.fw

diff --git a/WHENCE b/WHENCE
index 13cbcab..77e8531 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1972,3 +1972,14 @@ Source: isci/Makefile
 Licence: GPLv2
 
 --------------------------------------------------------------------------
+
+Driver: carl9170 -- Atheros AR9170 802.11 draft-n USB driver
+
+File: carl9170-1.fw
+Version: 1.9.6
+
+Downloaded from http://linuxwireless.org/en/users/Drivers/carl9170
+
+Licence: GPLv2
+
+--------------------------------------------------------------------------
diff --git a/carl9170-1.fw b/carl9170-1.fw
new file mode 100644
index 0000000000000000000000000000000000000000..05c1f48b96f3e2f66e77c15b7e1a7f016949276f
GIT binary patch
literal 13388
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
KOUwB1{(k@%W03Oz

literal 0
HcmV?d00001

-- 
1.7.10.4

