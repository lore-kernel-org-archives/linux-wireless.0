Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:11869 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbeA3QvH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 11:51:07 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/7] fixes to avoid use of cameCase
Date: Tue, 30 Jan 2018 22:20:26 +0530
Message-ID: <1517331033-5718-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180130_175110_628136_40EF3E8B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch set to fix "Avoid camelCase" issues found by checkpatch.pl.

Ajay Singh (7):
  staging: wilc1000: rename variables using camelCase in
    host_int_ParseJoinBssParam()
  staging: wilc1000: rename Handle_DelAllSta() and its variable using
    camelCase
  staging: wilc1000: rename strWIDList variable to avoid camelCase
  staging: wilc1000: rename u32WidsCount to avoid camelCase
  staging: wilc1000: rename pu8CurrByte variable to avoid camelCase
  staging: wilc1000: rename Handle_ScanDone function to avoid camelCase
  staging: wilc1000: rename Handle_Key() and Handle_ConnectTimeout()

 drivers/staging/wilc1000/host_interface.c | 726 +++++++++++++++---------------
 1 file changed, 363 insertions(+), 363 deletions(-)

-- 
2.7.4
