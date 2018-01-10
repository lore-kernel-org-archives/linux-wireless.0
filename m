Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:53792 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964979AbeAJLNy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 06:13:54 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 0/9] fixes to remove enum typedefs
Date: Wed, 10 Jan 2018 16:42:42 +0530
Message-ID: <1515582771-28408-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180110_121358_873600_598FF034)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v2: The patch series is created instead of independent patches & 
updated the name for Signed-off-by field. 
  
This patch series fix "WARNING: do not add new typedefs" issues
found by checkpatch.pl

Ajay Singh (9):
  staging: wilc1000: removed typedef from enum BSSTYPE_T
  staging: wilc1000: remove unnecessary typedef enum G_OPERATING_MODE_T
  staging: wilc1000: removed unnecessary enums typedefs
  staging: wilc1000: removed few unnecessary enums typedef
  staging: wilc1000: removed few unnecessary enums typedef
  staging: wilc1000: removed enums typedef for BEACON_IE & TX_RATE_T
  staging: wilc1000: removed enum typedef CHIP_PS_STATE_T
  staging: wilc1000: removed enum typedef BUS_ACQUIRE_T
  staging: wilc1000: removed enum typedef BUS_RELEASE_T

 drivers/staging/wilc1000/host_interface.c |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c      |  6 +-
 drivers/staging/wilc1000/wilc_wlan_if.h   | 96 +++++++++++++++----------------
 3 files changed, 52 insertions(+), 52 deletions(-)

-- 
2.7.4
