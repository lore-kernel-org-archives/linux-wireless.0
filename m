Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61677 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543AbZKLEbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 23:31:25 -0500
Date: Wed, 11 Nov 2009 22:31:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, bzolnier@gmail.com
Cc: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Subject: [RFC/RFT 0/6 V2] rtl8187se: Initial introduction of driver
Message-ID: <4afb8fa1.BSj+U96EOaXrlQvr%Larry.Finger@lwfinger.net>
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



