Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:30051 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752007AbeFZGHx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:53 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/12] staging: wilc1000: updated TODO file
Date: Tue, 26 Jun 2018 11:37:14 +0530
Message-ID: <1529993234-27294-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080756_852407_2A4CCAF7)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Item [1] in TODO list is already addressed, so removed it from TODO file.

[1]. Move handling for each individual members of 'union message_body' out
into a separate 'struct work_struct' and completely remove the
multiplexerthat is currently part of host_if_work(), allowing movement
of the implementation of each message handler into the callsite of the
function that currently queues the 'host_if_msg'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/TODO | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
index d123324..725bede 100644
--- a/drivers/staging/wilc1000/TODO
+++ b/drivers/staging/wilc1000/TODO
@@ -1,10 +1,5 @@
 TODO:
 - rework comments and function headers(also coding style)
-- Move handling for each individual members of 'union message_body' out
-  into a separate 'struct work_struct' and completely remove the multiplexer
-  that is currently part of host_if_work(), allowing movement of the
-  implementation of each message handler into the callsite of the function
-  that currently queues the 'host_if_msg'.
 - make spi and sdio components coexist in one build
 - support soft-ap and p2p mode
 - support resume/suspend function
-- 
2.7.4
