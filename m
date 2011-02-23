Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab1BWQOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 11:14:19 -0500
Date: Wed, 23 Feb 2011 10:14:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sfr@canb.auug.org.au, otavio@ossystems.com.br, w@1wt.eu,
	george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 0/5] rtlwifi: rtl8192cu: Fixes for ARM and allyes
 builds
Message-ID: <4d65325a.6DEYfypL/SHCDViw%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix problems with initial upload of rtl8192cu. The individual parts are:

 1/5: Fix build when RTL8192CU is selected, but RTL8192CE is not
 2/5: Fix build error for missing vmalloc header
 3/5: Fix for build error if PCI is not present
 4/5: Modify wifi.h for rtl8192cu
 5/5: Fix multiple def errors for allyesconfig build
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

These patches are fixes for ARM and allyesconfig builds of rtl8192cu and rtl8192ce.

Larry

