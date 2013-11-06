Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56994 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900Ab3KFTZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 14:25:23 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-wireless@vger.kernel.org>,
	<linux-bluetooth@vger.kernel.org>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: linux-firmware: pull-request Marvell mwifiex-firmware 2013-11-06
Date: Wed, 6 Nov 2013 11:25:13 -0800
Message-ID: <1383765913-19716-1-git-send-email-bzhao@marvell.com> (sfid-20131106_202533_576757_DE7A972F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 7d0c7a8cfd78388d90cc784a185b19dcbdbce824:

  Merge branch 'wilink4' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/linux-firmware (2013-10-13 21:11:46 +0100)

are available in the git repository at:


  git://git.marvell.com/mwifiex-firmware.git master

for you to fetch changes up to b7c848634538ff87317acd802fb4645cfd2f9fb5:

  linux-firmware: add Marvell SD8897-B0 firmware combo image (2013-11-04 16:03:34 -0800)

----------------------------------------------------------------
Bing Zhao (2):
      linux-firmware: update Marvell PCIe/USB 8897-B0 firmware combo image
      linux-firmware: add Marvell SD8897-B0 firmware combo image

 WHENCE                   |   5 ++++-
 mrvl/pcie8897_uapsta.bin | Bin 350244 -> 656896 bytes
 mrvl/sd8897_uapsta.bin   | Bin 0 -> 639012 bytes
 3 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 mrvl/sd8897_uapsta.bin

diff --git a/WHENCE b/WHENCE
index 2d52804..3875e77 100644
--- a/WHENCE
+++ b/WHENCE
@@ -727,11 +727,14 @@ Version: 14.66.9.p96
 File: mrvl/sd8797_uapsta.bin
 Version: 14.66.11.p151
 
+File: mrvl/sd8897_uapsta.bin
+Version: 15.69.2.p11
+
 File: mrvl/usb8797_uapsta.bin
 Version: 14.69.11.p179
 
 File: mrvl/pcie8897_uapsta.bin
-Version: 15.69.201.p52
+Version: 15.69.2.p11
 
 Licence: Redistributable. See LICENCE.Marvell for details.  Originates from
 http://git.marvell.com/?p=mwifiex-firmware.git
diff --git a/mrvl/pcie8897_uapsta.bin b/mrvl/pcie8897_uapsta.bin
index b067689..858c100 100644
Binary files a/mrvl/pcie8897_uapsta.bin and b/mrvl/pcie8897_uapsta.bin differ
diff --git a/mrvl/sd8897_uapsta.bin b/mrvl/sd8897_uapsta.bin
new file mode 100644
index 0000000..70732a6
Binary files /dev/null and b/mrvl/sd8897_uapsta.bin differ
