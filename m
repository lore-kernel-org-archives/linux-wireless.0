Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaAWQhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 11:37:18 -0500
Date: Thu, 23 Jan 2014 08:38:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [FIRMWARE PATCH] rtlwifi: Add firmware for rtl8821ae
Message-ID: <20140123163807.GA16360@kroah.com> (sfid-20140123_173728_083360_B453D048)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This firmware is for a driver for the Realtek 8821AE PCI WIFI device.
It came from a tarball from Realtek named
wifi_driver_8821ae_0018.1129.2013.tar.gz and is allowed to be
distributed under the LICENCE.rtlwifi_firmware.txt license.

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 WHENCE                  |   9 +++++++++
 rtlwifi/rtl8821aefw.bin | Bin 0 -> 29198 bytes
 2 files changed, 9 insertions(+)
 create mode 100644 rtlwifi/rtl8821aefw.bin

diff --git a/WHENCE b/WHENCE
index 00767b179a68..16ab53e2ba75 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1962,6 +1962,15 @@ Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
 
 --------------------------------------------------------------------------
 
+Driver: rtl8821ae - Realtek 802.11n WLAN driver for RTL8821AE
+
+Info: Taken from Realtek version wifi_driver_8821ae_0018.1129.2013.tar.gz
+File: rtlwifi/rtl8821ae.bin
+
+Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
+
+--------------------------------------------------------------------------
+
 Driver: r8169 - RealTek 8169/8168/8101 ethernet driver.
 
 File: rtl_nic/rtl8168d-1.fw
diff --git a/rtlwifi/rtl8821aefw.bin b/rtlwifi/rtl8821aefw.bin
new file mode 100644
index 0000000000000000000000000000000000000000..a8638976db23ecd0dddd618aad93e73108313ed6
GIT binary patch
literal 29198
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

literal 0
HcmV?d00001

-- 
1.8.5.1.163.gd7aced9

