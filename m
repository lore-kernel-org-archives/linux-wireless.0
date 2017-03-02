Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34799 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbdCBPfH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 10:35:07 -0500
From: Georgios Emmanouil <geo.emmnl@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Staging:wilc1000:host_interface: Removed unnecessary blank line
Date: Thu,  2 Mar 2017 17:35:05 +0200
Message-Id: <1488468905-8686-1-git-send-email-geo.emmnl@gmail.com> (sfid-20170302_163807_026456_0ACE9105)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed unnecessary blank line.

Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c307cce..090fd43 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -287,7 +287,6 @@ static int wilc_enqueue_cmd(struct host_if_msg *msg)
 	return 0;
 }

-
 /* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
  * As a result, the returned index will be 1 to NUM_CONCURRENT_IFC.
--
2.1.4
