Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:5765 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751310AbeCTQzx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 12:55:53 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/11] staging: wilc1000: fix for checkpatch and handled malloc memory properly
Date: Tue, 20 Mar 2018 22:25:33 +0530
Message-ID: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180320_175558_015777_3494F6F0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains fixes to avoid checkpatch issues and removed
unused code. Few patch contains changes related to NULL check and freeing of
dynamically allocated memory.


Ajay Singh (11):
  staging: wilc1000: refactor scan() to free kmalloc memory on failure
    cases
  staging: wilc1000: removed unused global variables for gtk and ptk
    information
  staging: wilc1000: remove line over 80 char warnings in
    set_wiphy_params()
  staging: wilc1000: refactor WILC_WFI_p2p_rx() to avoid line over 80
    char
  staging: wilc1000: rename WILC_WFI_p2p_rx & s32Freq to avoid camelCase
  staging: wilc1000: refactor mgmt_tx to fix line over 80 chars
  staging: wilc1000: rename hAgingTimer to avoid camelCase issue
  staging: wilc1000: fix line over 80 char issue in clear_shadow_scan()
  staging: wilc1000: remove line over 80 char in cfg_connect_result()
  staging: wilc1000: remove unused 'struct add_key_params'
  staging: wilc1000: remove line over 80 char warning in few functions

 drivers/staging/wilc1000/linux_wlan.c             |   2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 577 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wlan.h              |   2 +-
 3 files changed, 297 insertions(+), 284 deletions(-)

-- 
2.7.4
