Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:14571 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754829AbeCHPwC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:52:02 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/10] staging: wilc1000: fixes for checkpatch issues & coding style related
Date: Wed, 7 Mar 2018 07:43:49 +0530
Message-ID: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_165206_531770_7B485D0B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains modification to remove the checkpatch warnings
and changes to follow linux coding style.

Ajay Singh (10):
  staging: wilc1000: rename pstrHostIFconnectAttr to avoid camelCase
    issue
  staging: wilc1000: rename strConnectInfo to avoid camelCase
  staging: wilc1000: rename label 'ERRORHANDLER' to avoid uppercase name
  staging: wilc1000: fix line over 80 char in handle_scan()
  staging: wilc1000: fix line over 80 char in handle_connect()
  staging: wilc1000: fix line over 80 character in handle_disconnect()
  staging: wilc1000: rename variables prefix using datatype 'u8'
  staging: wilc1000: rename WILC_HostIf_PackStaParam to avoid camelCase
  staging: wilc1000: rename variables using camelCase in
    handle_rcvd_gnrl_async_info()
  staging: wilc1000: fix line over 80 char issue in handle_scan_done()

 drivers/staging/wilc1000/coreconfigurator.c |  28 +-
 drivers/staging/wilc1000/host_interface.c   | 580 ++++++++++++++--------------
 2 files changed, 308 insertions(+), 300 deletions(-)

-- 
2.7.4
