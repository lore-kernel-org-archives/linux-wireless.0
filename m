Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1ECOrh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 10:47:37 -0400
Date: Tue, 03 May 2011 09:47:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn
Subject: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
Message-ID: <4dc01587.AfSJXmRO80K/pl3f%Larry.Finger@lwfinger.net> (sfid-20110503_164757_952482_0639010F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches introduces a driver for the RTL8192SE PCI devices.

The patches are as follows:

01/12: Introduce file def.h
02/12: Introduce dynamic management routines dm.c and dm.h
03/12: Introduce firmware routines fw.c and fw.h
04/12: Introduce hardware control routines hw.c and hw.h
05/12: Introduce LED routines led.c and led.h
06/12: Introduce PHY routines phy.c and phy.h
07/12: Introduce register definition header
08/12: Introduce radio control routines
09/12: Introduce main routine (sw.c and sw.h)
10/12: Introduce tables
11/12: Introduce TX/RX routines
12/12: Modify Kconfig and Makefiles to build rtl8192se

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This material is for 2.6.40.

Larry

