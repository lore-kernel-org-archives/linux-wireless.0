Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0122.outbound.protection.outlook.com ([157.55.234.122]:11743
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756034AbbFPJtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 05:49:53 -0400
From: "Abdul, Hussain (H.)" <habdul@visteon.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Ravindran, Madhusudhanan (M.)" <mravindr@visteon.com>,
	"Dighe, Niranjan (N.)" <ndighe@visteon.com>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] Staging: wilc1000: Assign proper boolean value
Date: Tue, 16 Jun 2015 09:49:49 +0000
Message-ID: <1434448109-15017-1-git-send-email-habdul@visteon.com> (sfid-20150616_115017_205745_D02B8E4C)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abdul Hussain <habdul@visteon.com>

This patch assign proper boolean value to boolean variable.

Signed-off-by: Abdul Hussain <habdul@visteon.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 17ab5cd..be1f6bf 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7816,7 +7816,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 					pNewJoinBssParam->rsn_cap[1] = pu8IEs[rsnIndex + 1];
 					rsnIndex += 2;
 				}
-				pNewJoinBssParam->rsn_found = 1;
+				pNewJoinBssParam->rsn_found = true;
 				index += pu8IEs[index + 1] + 2; /* ID,Length bytes and IE body */
 				continue;
 			} else
-- 
1.9.1
