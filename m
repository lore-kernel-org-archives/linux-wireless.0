Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:34070 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbeHCMw3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 08:52:29 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 3/3] staging: wilc1000: remove TODO item for comments and code style
Date: Fri, 3 Aug 2018 16:26:15 +0530
Message-ID: <1533293775-22456-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180803_125648_480772_BC94A67C)
In-Reply-To: <1533293775-22456-1-git-send-email-ajay.kathat@microchip.com>
References: <1533293775-22456-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove below item from TODO as these changes were included as part of
previous submitted patch series.

'rework comments and function headers(also coding style)'

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/TODO | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
index 6fd3a4c..862e9ea 100644
--- a/drivers/staging/wilc1000/TODO
+++ b/drivers/staging/wilc1000/TODO
@@ -1,4 +1,3 @@
 TODO:
-- rework comments and function headers(also coding style)
 - support soft-ap and p2p mode
 - support resume/suspend function
-- 
2.7.4
