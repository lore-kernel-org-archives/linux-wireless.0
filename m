Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab1BSW2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 17:28:45 -0500
Date: Sat, 19 Feb 2011 16:28:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 0/16] rtlwifi: rtl8192cu: Add driver
Message-ID: <4d60441a.ZoWCvvdkjWyfVsrI%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add driver rtl192cu. The individual parts are:

 1/16: Make changes in rtlwifi/rtl8192ce/reg.h to support rtl8192cu
 2/16: Make changes in rtlwifi/rtl8192ce/def.h to support rtl8192cu
 3/16: Modify some rtl8192ce routines for merging rtl8192cu
 4/16: Add headers for rtl8187cu
 5/16: Modify wifi.h for rtl8192cu
 6/16: Move common parts of rtl8192ce/phy.c
 7/16: Add routines dm, fw, led and sw
 8/16: Add routine hw
 9/16: Add routine mac
10/16: Add routine phy
11/16: Add routine rf
12/16: Add routine table
13/16: Add routine trx
14/16: Modify buiild system for rtl8192cu
15/16: Fix endian warnings
16/16: Remove obsolete/unused macros

Signed-off-by: George <george0505@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This series of patches is intended for 2.6.39.

This material is available from the git repository at
git://git.kernel.org/pub/scm/linux/kernel/git/lwfinger/rtl8192cu.git

V1 => V2: Fix endian issues in rtl8192cu and rtl8192ce
	  Added options to Makefile so that sparse tests always include endian issues
	  Get rid of additional Hungarian notation
	  Delete obsolete and unused macros

Larry

