Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbeBTO6J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:09 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/12] staging: wilc1000: fixes to avoid use of camelCase in host interface
Date: Tue, 20 Feb 2018 20:27:49 +0530
Message-ID: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155813_211376_94BD54DB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains fixes for "Avoid camelCase" issues found by
checkpatch.pl script.

Ajay Singh (12):
  staging: wilc1000: rename pu8HdnNtwrksWidVal to avoid camelCase
  staging: wilc1000: rename ptstrJoinBssParam to avoid camelCase
  staging: wilc1000: rename variables using camelCase in
    handle_rcvd_ntwrk_info()
  staging: wilc1000: rename pu32InactiveTime to avoid camelCase
  staging: wilc1000: rename Handle_SetMulticastFilter to avoid camelCase
  staging: wilc1000: rename pstrSetBeaconParam to avoid camelCase
  staging: wilc1000: rename pstrStatistics to avoid camelCase
  staging: wilc1000: rename strDisconnectNotifInfo to avoid camelCase
  staging: wilc1000: rename pstrDelStaParam to avoid camelCase
  staging: wilc1000: rename pstrStationParam to avoid camelCase
  staging: wilc1000: rename _WPAPtk_end_case_ label to avoid camelCase
  staging: wilc1000: rename _WPARxGtk_end_case_ label to avoid camelCase

 drivers/staging/wilc1000/host_interface.c | 299 +++++++++++++++---------------
 1 file changed, 147 insertions(+), 152 deletions(-)

-- 
2.7.4
