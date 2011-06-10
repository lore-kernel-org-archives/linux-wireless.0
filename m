Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33114 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab1FJUI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 16:08:56 -0400
Date: Fri, 10 Jun 2011 15:08:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 00/13] Initial submission of driver rtl8192de
Message-ID: <4df279d6.s0xm0gXgTtCYGr4l%Larry.Finger@lwfinger.net> (sfid-20110610_220859_776247_BB310ED9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches adds a new driver for the Realtek RTL8192DE family
of devices. The driver is intended to be included in kernel 3.1.

Included are the following:

01/13: rtlwifi: rtl8192de: Merge def.h
02/13: rtlwifi: rtl8192de: Merge dynamic management routines
03/13: rtlwifi: rtl8192de: Merge firmware routines
04/13: rtlwifi: rtl8192de: Merge hardware routines
05/13: rtlwifi: rtl8192de: Merge led routines
06/13: rtlwifi: rtl8192de: Merge phy routines
07/13: rtlwifi: rtl8192de: Merge register definitions
08/13: rtlwifi: rtl8192de: Merge rf routines
09/13: rtlwifi: rtl8192de: Merge main (sw) routines
10/13: rtlwifi: rtl8192de: Merge table routines
11/13: rtlwifi: rtl8192de: Merge TX and RX routines
12/13: rtlwifi: Fix build problems introduced by merging rtl8192de
13/13: rtlwifi: rtl8192de: Modify Kconfig and Makefile routines for new driver

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

