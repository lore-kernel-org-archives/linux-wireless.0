Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48301 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbbG1IuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:50:24 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 21/21] staging: wilc1000: update TODO list of WILC1000
Date: Tue, 28 Jul 2015 17:47:40 +0900
Message-ID: <1438073261-28315-22-git-send-email-tony.cho@atmel.com> (sfid-20150728_105034_015677_BA1D2B73)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TODO list is updated for the WILC1000 kernel driver. The TODO list
contains many items listed in time sequence.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/TODO | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
index 95199d8..6b745cd 100644
--- a/drivers/staging/wilc1000/TODO
+++ b/drivers/staging/wilc1000/TODO
@@ -1,14 +1,15 @@
 TODO:
-- remove the defined feature as kernel versions
-- remove OS wrapper functions
-- remove custom debug and tracing functions
+- remove most of warnings reported by checkpatch.pl
+- remove OS wrapper functions to use kernel API as is
 - rework comments and function headers(also coding style)
 - replace all semaphores with mutexes or completions
-- make spi and sdio components coexist in one build
+- remove compile warnings related to 64 bit machine
 - turn compile-time platform configuration (BEAGLE_BOARD,
   PANDA_BOARD, PLAT_WMS8304, PLAT_RKXXXX, CUSTOMER_PLATFORM, ...)
   into run-time options that are read from DT
-- support soft-ap and p2p mode
-- support resume/suspend function
+- support soft-ap and p2p mode by updating the WILC1000 driver and fw
+- support resume/suspend function by updating the WILC1000 driver and fw
 - replace SIOCDEVPRIVATE commands with generic API functions
 - use wext-core handling instead of private SIOCSIWPRIV implementation
+- replace CamelCase to follow coding style
+- remove the warnings, line over 80 characters
-- 
1.9.1

