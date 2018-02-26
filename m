Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:18206 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751724AbeBZQfq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:35:46 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/8] staging: wilc1000: fix coding style & checkpatch reported issues
Date: Mon, 26 Feb 2018 22:01:54 +0530
Message-ID: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180226_173550_035658_783ABDDA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch series to fix checkpatch.pl reported issue & code
modification to follow linux coding style.

Ajay Singh (8):
  staging: wilc1000: remove unnecessary while(0) in
    wilc_wlan_handle_txq()
  staging: wilc1000: rename label _end_ in wilc_wlan_handle_txq()
  staging: wilc1000: fix line over 80 char in wilc_wlan_handle_txq()
  staging: wilc1000: move multiple definition of same macro to common
    header
  staging: wilc1000: rename WILC_WFI_mgmt_rx() to avoid camelCase
  staging: wilc1000: fix line over 80 char in wilc_wlan_handle_rxq()
  staging: wilc1000: fix line over 80 char in wilc_wlan_cfg_set()
  staging: wilc1000: fix open parenthesis mismatch issue in
    wilc_wlan_cfg_set()

 drivers/staging/wilc1000/linux_mon.c              |   3 -
 drivers/staging/wilc1000/linux_wlan.c             |   2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   3 -
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c              | 361 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wlan.h              |   5 +
 6 files changed, 183 insertions(+), 193 deletions(-)

-- 
2.7.4
