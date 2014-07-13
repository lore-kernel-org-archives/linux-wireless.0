Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57310 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaGMJnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:51 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so2098827wgh.26
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:49 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/13] staging: vt6656: wcnd.c clean up comments
Date: Sun, 13 Jul 2014 10:42:53 +0100
Message-Id: <1405244573-10978-13-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114408_499337_D7380C0C)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing old functions and comments.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 3c65228..bf41e67 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -25,14 +25,9 @@
  * Date: May 8, 2003
  *
  * Functions:
- *      s_vProbeChannel - Active scan channel
- *      s_MgrMakeProbeRequest - Make ProbeRequest packet
- *      CommandTimer - Timer function to handle command
  *	vnt_cmd_complete - Command Complete function
- *      vnt_schedule_command - Push Command and wait Command Scheduler to do
- *      vCommandTimer- Command call back functions
+ *	vnt_schedule_command - Push Command and wait Command Scheduler to do
  *	vnt_cmd_timer_wait- Call back timer
- *      s_bClearBSSID_SCAN- Clear BSSID_SCAN cmd in CMD Queue
  *
  * Revision History:
  *
@@ -174,7 +169,7 @@ void vnt_run_command(struct work_struct *work)
 
 	default:
 		break;
-	} //switch
+	}
 
 	vnt_cmd_complete(priv);
 
-- 
1.9.1

