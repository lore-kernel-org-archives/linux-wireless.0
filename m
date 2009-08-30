Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:59341 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZH3XcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 19:32:10 -0400
Received: by ey-out-2122.google.com with SMTP id 25so716028eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2009 16:32:12 -0700 (PDT)
Message-ID: <4A9B0BF8.3040505@lwfinger.net>
Date: Sun, 30 Aug 2009 18:32:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Inter 5300 AGN with unsupported EEPROM
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette,

While helping on the openSUSE wireless forum, I ran across another
unit with the same unsupported EEPROM as in the thread at
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1997.

The thread at openSUSE is at
 http://forums.opensuse.org/network-internet/wireless/420589-intel-5300-wifi-minipci-card-asus-g71gx-rx05-bestbuy-3.html

Most of the thread is useless as the OP wouldn't supply critical data
and persisted in various rants, but on the 3rd page, he finally
provided the output of 'dmesg | grep iwl', which was

iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
iwlagn: Copyright(c) 2003-2008 Intel Corporation
iwlagn 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:07:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
iwlagn: Unsuported EEPROM VER=0x114 < 0x11a CALIB=0x3 < 0x4
iwlagn 0000:07:00.0: PCI INT A disabled
iwlagn: probe of 0000:07:00.0 failed with error -22

The OP states that this device came from Best Buy. What is the current
scoop on this EEPROM version?

Thanks,

Larry

