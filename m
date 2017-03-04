Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35992 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbdCDP6P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 10:58:15 -0500
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: w.d.hubbs@gmail.com
Cc: chris@the-brannons.com, outreachy-kernel@googlegroups.com,
        kirk@reisers.ca, samuel.thibault@ens-lyon.org,
        gregkh@linuxfoundation.org, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        linux-wireless@vger.kernel.org,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 3/6] staging: speakup: identation should use tabs
Date: Sat,  4 Mar 2017 21:27:37 +0530
Message-Id: <20170304155740.26105-4-arushisinghal19971997@gmail.com> (sfid-20170304_165908_314636_936C1276)
In-Reply-To: <20170304155740.26105-1-arushisinghal19971997@gmail.com>
References: <20170304155740.26105-1-arushisinghal19971997@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indentation should always use tabs and never spaces.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/staging/speakup/speakup_decpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/speakup/speakup_decpc.c b/drivers/staging/speakup/speakup_decpc.c
index dc860c4b8279..c5d1660da5be 100644
--- a/drivers/staging/speakup/speakup_decpc.c
+++ b/drivers/staging/speakup/speakup_decpc.c
@@ -85,8 +85,8 @@
 #define	CTRL_io_priority	0x0c00	/*   change i/o priority */
 #define	CTRL_free_mem		0x0d00	/*   get free paragraphs on module */
 #define	CTRL_get_lang		0x0e00	/* return bit mask of loaded
-					         * languages
-					         */
+						 * languages
+						 */
 #define	CMD_test			0x2000		/* self-test request */
 #define	TEST_mask		0x0F00	/* isolate test field */
 #define	TEST_null		0x0000	/* no test requested */
-- 
2.11.0
