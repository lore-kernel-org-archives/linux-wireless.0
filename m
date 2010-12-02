Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58401 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab0LBBb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 20:31:57 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 00/31] wireless: Marvell mwifiex driver for SD8787
Date: Wed,  1 Dec 2010 17:31:56 -0800
Message-Id: <1291253516-17815-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mwifiex driver for Marvell 802.11n chipset SD8787 is available at
git://git.marvell.com/mwifiex.git. Both STA mode and Mobile hotspot
mode are supported.

git pull git://git.marvell.com/mwifiex.git master


The firmware image for SD8787 is also available at:
git://git.marvell.com/mwifiex-firmware.git

---

The following changes since commit 56174316 or tag "master-2010-11-30":

Amitkumar Karwar (17):
  mwifiex: move netdev init code out of _cfg80211
  mwifiex: uAP: bring up uAP interface
  mwifiex: uAP: add basic uAP support
  mwifiex: uAP: add data path support
  mwifiex: uAP: fix kernel crash while loading the driver
  mwifiex: do not hold off cfg80211 callback for scan
  mwifiex: make tx_buf_size alignment
  mwifiex: correct short_time_slot setting for B-only mode
  mwifiex: catch failure status in cmd response handler
  mwifiex: change default settings of aggrpriotbl
  mwifiex: fill in HT cap info correctly
  mwifiex: correct WEP status setting
  mwifiex: update copyright descriptions
  mwifiex: improve re-transmit handling
  mwifiex: prevent spurious error messages
  mwifiex: accept hex values for debugfs command drvdbg
  mwifiex: fix errors found by checkpatch.pl

Bing Zhao (12):
  wireless: mwifiex: initial commit for Marvell mwifiex driver
  mwifiex: fix error and warning after rebased to 2.6.37-rc1
  mwifiex: add WPS support
  mwifiex: fix coding style warning: suspect code indent
  mwifiex: handle error cases if init commands fail
  mwifiex: move re-order table cleanup out of TX spinlock
  mwifiex: fix warm-reset crash issue
  mwifiex: get power save status in STA-AP mode
  mwifiex: set sysfs physical device reference for netdev
  mwifiex: fix checkpatch.pl warning
  mwifiex: remove MWIFIEX_PACK_START
  mwifiex: remove mwifiex_ prefix from the filenames

Kiran Divekar (2):
  mwifiex: handle erroneous response of sleep confirm
  mwifiex: set card quirk MMC_QUIRK_BLKSZ_FOR_BYTE_MODE

