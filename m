Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47297 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab2FMOO3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 10:14:29 -0400
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id q5DEETaV004674
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 09:14:29 -0500
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id q5DEESgr022545
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 09:14:28 -0500
From: Yair Shapira <yair.shapira@ti.com>
To: <linux-wireless@vger.kernel.org>, <coelho@ti.com>
CC: <yair.shapira@ti.com>
Subject: [PATCH 0/2] wlcore/wl12xx: add suppoprt for HP and SKW FEM radio manufacturers
Date: Wed, 13 Jun 2012 17:14:20 +0300
Message-ID: <1339596862-2488-1-git-send-email-yair.shapira@ti.com> (sfid-20120613_161432_867068_19F6C522)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for HP(High Performance TQS fem type 3) and SKW (fem type 2)
in radio params. BIP Calibration (PLT mode) of new radio types is supported
In addition new log added to display BIP calibration radio_status

Yair Shapira (2):
  wlcore/wl12xx: add suppoprt for HP and SKW FEM radio manufacturers
  wlcore: add print logs of radio_status in case of BIP calibration

 drivers/net/wireless/ti/wl12xx/cmd.c      |   16 ++++++++++------
 drivers/net/wireless/ti/wlcore/cmd.h      |   21 +++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/ini.h      |   22 +++++++++++++++++-----
 drivers/net/wireless/ti/wlcore/testmode.c |   14 ++++++++++++++
 4 files changed, 62 insertions(+), 11 deletions(-)
 mode change 100644 => 100755 drivers/net/wireless/ti/wl12xx/cmd.c
 mode change 100644 => 100755 drivers/net/wireless/ti/wlcore/cmd.h
 mode change 100644 => 100755 drivers/net/wireless/ti/wlcore/ini.h
 mode change 100644 => 100755 drivers/net/wireless/ti/wlcore/testmode.c

-- 
1.7.9.5

