Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:9146 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933305AbeAKPIy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 10:08:54 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 0/6] fixes to remove enum typedefs
Date: Thu, 11 Jan 2018 19:42:13 +0530
Message-ID: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180111_160857_893863_6D99218A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes since v2: Removed v2 patch number 3,4,5 , where were handling
	different changes under same subject line.
	As those changes were independent, will work on those items and
	send as separate patch later.
	

Ajay Singh (6):
  staging: wilc1000: removed typedef from enum BSSTYPE_T
  staging: wilc1000: remove unnecessary typedef enum G_OPERATING_MODE_T
  staging: wilc1000: removed enums typedef for BEACON_IE & TX_RATE_T
  staging: wilc1000: removed enum typedef CHIP_PS_STATE_T
  staging: wilc1000: removed enum typedef BUS_ACQUIRE_T
  staging: wilc1000: removed enum typedef BUS_RELEASE_T

 drivers/staging/wilc1000/host_interface.c |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c      |  6 +++---
 drivers/staging/wilc1000/wilc_wlan_if.h   | 28 ++++++++++++++--------------
 3 files changed, 18 insertions(+), 18 deletions(-)

-- 
2.7.4
