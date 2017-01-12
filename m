Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from box.matheina.com ([104.236.11.237]:35718 "EHLO box.matheina.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752770AbdALDpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 22:45:15 -0500
From: Scott Matheina <scott@matheina.com>
To: linux-kernel@vger.kernel.org
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 2/7] staging:wilc1000:host_interface.c Added braces {} on else statemement
Date: Wed, 11 Jan 2017 21:38:33 -0600
Message-Id: <1484192328-16825-2-git-send-email-scott@matheina.com> (sfid-20170112_044530_437933_26C941D0)
In-Reply-To: <1484192328-16825-1-git-send-email-scott@matheina.com>
References: <1484192328-16825-1-git-send-email-scott@matheina.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warning: braces {} should be used on all arms of
this statement

Signed-off-by: Scott Matheina <scott@matheina.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b00ea75..c307cce 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3998,8 +3998,9 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 				pNewJoinBssParam->rsn_found = true;
 				index += pu8IEs[index + 1] + 2;
 				continue;
-			} else
+			} else {
 				index += pu8IEs[index + 1] + 2;
+			}
 		}
 	}
 
-- 
2.7.4
