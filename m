Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:22449 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754612AbeCHPKq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:10:46 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/10] staging: wilc1000: fixes related to camelCase & line over 80 chars
Date: Wed, 7 Mar 2018 07:02:20 +0530
Message-ID: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_161050_016292_2B470E84)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch series contains fixes to remove checkpatch reported warnings.

Ajay Singh (10):
  staging: wilc1000: rename strHiddenNetwork to avoid camelCase
  staging: wilc1000: rename pstrNetworkInfo to avoid camelCase
  staging: wilc1000: rename CfgScanResult to avoid camelCase
  staging: wilc1000: rename au8ScanChanList to avoid camelCase
  staging: wilc1000: fix line over 80 char in change_virtual_intf()
  staging: wilc1000: fix line over 80 char in get_key() &
    set_default_key()
  staging: wilc1000: fix line over 80 char for cfg parse RX and TX
    function
  staging: wilc1000: fix line over 80 char in mgmt_tx_cancel_wait()
  staging: wilc1000: rename pJoinParams to avoid camelCase
  staging: wilc1000: fix line over 80 char in cfg_scan_result()

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 329 +++++++++++-----------
 1 file changed, 168 insertions(+), 161 deletions(-)

-- 
2.7.4
