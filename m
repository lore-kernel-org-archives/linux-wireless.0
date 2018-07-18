Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:48703 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbeGSGpq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:45:46 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/23] staging: wilc1000: cleanup patch to follow linux coding style
Date: Thu, 19 Jul 2018 04:14:56 +0530
Message-ID: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080424_702314_5DFA71E0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains modification to follow Linux coding style &
cleanup change to remove unused variables and enums.
Few patches also contain changes to remove unnecessary typecast.

Ajay Singh (23):
  staging: wilc1000: remove unused enum declaration
  staging: wilc1000: remove enum connect_status instead use
    ieee80211_statuscode
  staging: wilc1000: remove extra enum defined for data rates
  staging: wilc1000: remove extra enums defined for ieee80211_eid
  staging: wilc1000: rename goto to avoid leading '_' in label name
  staging: wilc1000: rename enum CURRENT_TXRATE to use lowercase
  staging: wilc1000: rename enum SITESURVEY to use lowercase
  staging: wilc1000: rename enum AUTHTYPE to use lowercase
  staging: wilc1000: remove unused elements in 'wilc' struct
  staging: wilc1000: remove unnecessary elements from 'wilc_priv' struct
  staging: wilc1000: removed unused element from wilc_cfg_frame struct
  staging: wilc1000: remove the mutliple #define used for same macro
  staging: wilc1000: use lowercase for 'IFC_UP' struct element name
  staging: wilc1000: remove unnecessary blank line between variable
    declaration
  staging: wilc1000: use single space before opening brances '{'
  staging: wilc1000: remove unnecessary type used for wid id
  staging: wilc1000: avoid forward declaration for handle_scan_done()
  staging: wilc1000: avoid host_int_get_assoc_res_info() forward
    declaration
  staging: wilc1000: avoid forward declaration of
    host_int_parse_join_bss_param()
  staging: wilc1000: avoid setting default value for variable at
    declaration
  staging: wilc1000: use 'int' inplace of 's32' date type
  staging: wilc1000: remove unnecessary 'NULL' check from cfg80211_ops
    callbacks
  staging: wilc1000: move variable assignment along with its declaration

 drivers/staging/wilc1000/coreconfigurator.c       |  84 +--
 drivers/staging/wilc1000/coreconfigurator.h       |  20 -
 drivers/staging/wilc1000/host_interface.c         | 696 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         |  20 +-
 drivers/staging/wilc1000/linux_mon.c              |   2 -
 drivers/staging/wilc1000/linux_wlan.c             | 122 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 307 +++-------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  16 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  65 +-
 drivers/staging/wilc1000/wilc_wlan.h              |   3 -
 drivers/staging/wilc1000/wilc_wlan_if.h           |  56 +-
 11 files changed, 517 insertions(+), 874 deletions(-)

-- 
2.7.4
