Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64198 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbZKIX1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:27:34 -0500
Date: Mon, 09 Nov 2009 17:27:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Subject: [RFT 0/6] rtl8187se: Initial introduction of driver
Message-ID: <4af8a56a.fCJY51VFS93aEZ0t%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patches to introduce a driver for the RTL8187SE PCI-based device.

Note: This driver is only compile-tested and will require more work
for it to be useful. I'm posting now to let others know what I have done.

I have applied for an account at kernel.org. If my request is approved, I
plan to establish an rtl8187se git tree.

Patch 1/6: Create file rtl8187se.h
Patch 2/6: Create file rtl8187se_dev.c
Patch 3/6: Create file rtl8187se_rtl8225.c
Patch 4/6: Create file rtl8187se_rtl8225.h
Patch 5/6: Modify file rtl818x.h
Patch 6/6: Modify Kconfig and Makefile for rtl8187se

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

