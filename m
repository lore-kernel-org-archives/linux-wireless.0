Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52122 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2F0AIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 20:08:11 -0400
Received: by wgbdr13 with SMTP id dr13so431997wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 17:08:09 -0700 (PDT)
Message-ID: <4FEA4EE6.2070401@gmail.com> (sfid-20120627_020815_064756_65E358A6)
Date: Wed, 27 Jun 2012 02:08:06 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: dsd@gentoo.org, kune@deine-taler.de,
	linux-wireless <linux-wireless@vger.kernel.org>,
	dwmw2@infradead.org, ben@decadent.org.uk
Subject: ZyDAS zd1211/zd1211b fw
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

ZyDAS zd1211/zd1211b firmware are missing in linux-firmware.git,
readme says:

--cut--
README

This distribution contains the firmware files for the
ZD1211 chip, which is used in WLAN USB sticks. Copy the zd1211_* files to
/lib/firmware/zd1211, where they can be loaded by the rewritten
zd1211 driver.

The files are generated from C header files distributed in the
original ZyDAS ZD1211 driver under the GNU Public License.

The full source of the original ZYDAS driver is available from
http://zd1211.wiki.sourceforge.net/VendorDriver

The GPL-licensed header files used to produce the firmware blobs are also
present in this distribution. See the COPYING file for the full license terms.

HISTORY

VERSION 1.4 (2007-10-04)
Sync to vendor driver v2.21.0.0
According to Atheros, this firmware fixes a USB disconnect issue which most
commonly appeared when running "lsusb" or "cat /proc/usb/devices" while using
the device.

VERSION 1.3 (2006-12-30)
Sync to vendor driver v2.16.0.0
Large packet support is now disabled. The zd1211 firmware is now the same as
v1.1 but the zd1211b firmware is new: It is the same which is shipped in the
2.10.0.0 release which supposedly fixes a "reboot issue"

VERSION 1.2 (2006-07-22)
Sync to vendor driver v2.13.0.0
Release notes mention that this firmware includes largepacket support

VERSION 1.1 (2006-04-30)
Added ZD1211B firmware files

VERSION 1.0 (2006-04-16)
This firmware has been generated from fersion 2_5_0_0 of the Zydas
driver, 2006-04-16.
--end--

So zero troubles to be at linux-firmware.git, can anyone submit a patch ?

latest fw at: http://netcologne.dl.sourceforge.net/project/zd1211/zd1211-firmware/1.4/

-thanks-
