Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5430 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbeAPOCn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:02:43 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/13] Changes to avoid CamelCase and removed unused variable
Date: Tue, 16 Jan 2018 19:32:18 +0530
Message-ID: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150247_796009_F3A36B4A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains changes to avoid use of CamelCase for variable names.
Also removed the unused variable in wilc_wfi_p2p_listen_params struct.

Ajay Singh (13):
  staging: wilc1000: rename elements of wilc_priv struct to avoid using
    camelCase
  staging: wilc1000: rename wilc_wfi_p2pListenParams struct and its
    member variable
  staging: wilc1000: rename au8Sta_AssociatedBss element sta_info
    structure
  staging: wilc1000: remove unused element in wilc_wfi_p2p_listen_params
    struct
  staging: wilc1000: rename s32Error variable to avoid camelCase
    notation
  staging: wilc1000: rename CfgConnectResult() and its local variable
    names
  staging: wilc1000: rename camelCase used in functions start with
    WILC_WFI_Cfg
  staging: wilc1000: rename pstrWFIDrv to wfi_drv to avoid camelCase
    naming
  staging: wilc1000: rename NullBssid to null_bssid to avoid camelCase
    variable name
  staging: wilc1000: rename variables using camelCase in add_key()
  staging: wilc1000: rename strStaParams variable to avoid camelCase
  staging: wilc1000: rename pstrCfgParamVal varaible in
    set_wiphy_params()
  staging: wilc1000: rename strStatistics & tenuAuth_type to avoid
    camelCase

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 526 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  29 +-
 2 files changed, 277 insertions(+), 278 deletions(-)

-- 
2.7.4
