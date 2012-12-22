Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:45908 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2LVXSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 18:18:10 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: RFCv2: ST-E cw1200 driver
Date: Sat, 22 Dec 2012 18:18:15 -0500
Message-Id: <1356218312-13616-1-git-send-email-pizza@shaftnet.org> (sfid-20121223_001820_136979_B1186603)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okay, here's the second pass.  Changes from v1:

 * Nuked all references to CONFIG_WAKELOCK
 * Nuked CONFIG_CW1200_WAPI_SUPPORT (support mainlined)
 * Nuked CONFIG_CW1200_WSM_DUMPS_SHORT and associated code
 * Converted printk() into appropriate pr_*() calls
 * Nuked the myriad CONFIG_CW1200_*_DEBUG options
 * Replaced STUB() calls with more specific errors
 * All checkpatch errors fixed
 * Clean up bss_loss_status before cancelling loss workers
 * Nuked or integrated all STE_EXTENSIONS-wrapped code

To-do:

 * Fix/Audit metric boatload of checkpatch warnings
 * Fix/Audit remaining build warnings
 * Fix IBSS
 * Achieve world peace

This code has only been compile-tested as I won't have access to real 
hardware until Monday.  I anticipate at least one more patch cycle.

Again, feedback welcome!

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>

