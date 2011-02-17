Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62120 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1BQVSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 16:18:03 -0500
Date: Thu, 17 Feb 2011 15:18:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/14] rtlwifi: rtl8192cu: Add driver
Message-ID: <4d5d9088.+yc+uIIeTakXOvtB%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add driver rtl192cu. The individual parts are:

 1/14: Make changes in rtlwifi/rtl8192ce/reg.h to support rtl8192cu
 2/14: Make changes in rtlwifi/rtl8192ce/def.h to support rtl8192cu
 3/14: Modify some rtl8192ce routines for merging rtl8192cu
 4/14: Add headers for rtl8187cu
 5/14: Modify wifi.h for rtl8192cu
 6/14: Move common parts of rtl8192ce/phy.c
 7/14: Add routines dm, fw, led and sw
 8/14: Add routine hw
 9/14: Add routine mac
10/14: Add routine phy
11/14: Add routine rf
12/14: Add routine table
13/14: Add routine trx
14/14: Modify buiild system for rtl8192cu

Signed-off-by: George <george0505@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This series of patches is intended for 2.6.39.

Larry

