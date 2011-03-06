Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50890 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1CFGgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 01:36:07 -0500
Date: Sun, 06 Mar 2011 00:36:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [RFC/RFT 0/11] rtlwifi: rtl8192se: Merge new driver
Message-ID: <4d732b50.jiYdcLhAW6PZf7C3%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches merges a new driver for the RTL8192SE device.

 1/11: rtlwifi: rtl8192se: Merge routines for dynamic management
 2/11: rtlwifi: rtl8192se: Merge routines for firmware loading
 3/11: rtlwifi: rtl8192se: Merge routines for device specific hardware access
 4/11: rtlwifi: rtl8192se: Merge routines for LED handling
 5/11: rtlwifi: rtl8192se: Merge routines for PHY handling
 6/11: rtlwifi: rtl8192se: Merge register definition routine
 7/11: rtlwifi: rtl8192se: Merge routines for RF handling
 8/11: rtlwifi: rtl8192se: Merge routines for initialization
 9/11: rtlwifi: rtl8192se: Merge routines for tables
10/11: rtlwifi: rtl8192se: Merge routines for TX and RX
11/11: rtlwifi: rtl8192se: Modify rtlwifi routines to handle rtl8192se add Makefile and Kconfig
---

John,

This driver is the one you asked about a couple of days ago. If possible to get this in
2.6.39, please do so.

Larry

