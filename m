Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:41422 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769Ab3EWSwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 14:52:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-wireless@vger.kernel.org>, Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: linux-firmware: pull-request Marvell mwifiex-firmware 2013-05-23
Date: Thu, 23 May 2013 11:49:52 -0700
Message-ID: <1369334992-10587-1-git-send-email-bzhao@marvell.com> (sfid-20130523_205215_011560_D449D529)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 07ea598af5b9dde3acdf279846b062fa1b2987b8:

  Merge branch 'linux-firmware' of git://github.com/TI-OpenLink/firmwares (2013-05-06 14:21:49 +0100)

are available in the git repository at:


  git://git.marvell.com/mwifiex-firmware.git master

for you to fetch changes up to 009719f9eca7a9d61b9c3cba5dbafbf937d93c80:

  linux-firmware: add Marvell PCIe8897-B0 WLAN firmware image (2013-05-22 18:23:52 -0700)

----------------------------------------------------------------
Bing Zhao (1):
      linux-firmware: add Marvell PCIe8897-B0 WLAN firmware image

 WHENCE                   |   5 ++++-
 mrvl/pcie8897_uapsta.bin | Bin 0 -> 350244 bytes
 2 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 mrvl/pcie8897_uapsta.bin

diff --git a/WHENCE b/WHENCE
index c08336a..d1a2713 100644
--- a/WHENCE
+++ b/WHENCE
@@ -716,7 +716,7 @@ directly by Marvell.
 
 --------------------------------------------------------------------------
 
-Driver: mwifiex - Marvell Wi-Fi fullmac-type 802.11n card
+Driver: mwifiex - Marvell Wi-Fi fullmac-type 802.11n/ac cards
 
 File: mrvl/sd8787_uapsta.bin
 Version: 14.66.9.p96
@@ -727,6 +727,9 @@ Version: 14.66.11.p151
 File: mrvl/usb8797_uapsta.bin
 Version: 14.69.11.p179
 
+File: mrvl/pcie8897_uapsta.bin
+Version: 15.69.201.p52
+
 Licence: Redistributable. See LICENCE.Marvell for details.  Originates from
 http://git.marvell.com/?p=mwifiex-firmware.git
 
diff --git a/mrvl/pcie8897_uapsta.bin b/mrvl/pcie8897_uapsta.bin
new file mode 100644
index 0000000..b067689
Binary files /dev/null and b/mrvl/pcie8897_uapsta.bin differ
