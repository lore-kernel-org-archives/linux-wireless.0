Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65489 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800AbaAJDsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 22:48:18 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-wireless@vger.kernel.org>,
	<linux-bluetooth@vger.kernel.org>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: linux-firmware: pull-request Marvell mwifiex-firmware 2014-01-09
Date: Thu, 9 Jan 2014 19:48:11 -0800
Message-ID: <1389325691-21371-1-git-send-email-bzhao@marvell.com> (sfid-20140110_044824_226941_10E64F43)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 52d77db9f133afe4d2b26aeccfd603745f45fda1:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware (2013-12-30 15:22:40 +0100)

are available in the git repository at:


  git://git.marvell.com/mwifiex-firmware.git master

for you to fetch changes up to 2d4aa2037a7015c4d78cde40006f80b8012537a6:

  linux-firmware: add Marvell USB8897-B0 firmware combo image (2014-01-09 19:17:35 -0800)

----------------------------------------------------------------
Bing Zhao (3):
      linux-firmware: update Marvell USB8797-B0 firmware image
      linux-firmware: update Marvell SD8897-B0 firmware combo image
      linux-firmware: add Marvell USB8897-B0 firmware combo image

 WHENCE                  |   7 +++++--
 mrvl/sd8897_uapsta.bin  | Bin 639012 -> 668028 bytes
 mrvl/usb8797_uapsta.bin | Bin 508372 -> 541048 bytes
 mrvl/usb8897_uapsta.bin | Bin 0 -> 705364 bytes
 4 files changed, 5 insertions(+), 2 deletions(-)
 create mode 100644 mrvl/usb8897_uapsta.bin

diff --git a/WHENCE b/WHENCE
index 4f87d8a..23faafa 100644
--- a/WHENCE
+++ b/WHENCE
@@ -730,10 +730,13 @@ File: mrvl/sd8797_uapsta.bin
 Version: 14.66.11.p151
 
 File: mrvl/sd8897_uapsta.bin
-Version: 15.69.2.p11
+Version: 15.68.201.p113
 
 File: mrvl/usb8797_uapsta.bin
-Version: 14.69.11.p179
+Version: 14.68.29.p26
+
+File: mrvl/usb8897_uapsta.bin
+Version: 15.68.201.p113
 
 File: mrvl/pcie8897_uapsta.bin
 Version: 15.69.2.p11
diff --git a/mrvl/sd8897_uapsta.bin b/mrvl/sd8897_uapsta.bin
index 70732a6..e68a049 100644
Binary files a/mrvl/sd8897_uapsta.bin and b/mrvl/sd8897_uapsta.bin differ
diff --git a/mrvl/usb8797_uapsta.bin b/mrvl/usb8797_uapsta.bin
index bd7c07c..1963798 100644
Binary files a/mrvl/usb8797_uapsta.bin and b/mrvl/usb8797_uapsta.bin differ
diff --git a/mrvl/usb8897_uapsta.bin b/mrvl/usb8897_uapsta.bin
new file mode 100644
index 0000000..59aef78
Binary files /dev/null and b/mrvl/usb8897_uapsta.bin differ
