Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:4141 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbeEBHOy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:14:54 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/21] staging: wilc1000: code cleanup & checkpatch fixes 
Date: Wed, 2 May 2018 12:43:26 +0530
Message-ID: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_092056_945776_6E2AB60F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains fixes to remove unused code and changes for
checkpatch.pl script reported issues.

Ajay Singh (21):
  staging: wilc1000: remove inner block in wilc_netdev_init()
  staging: wilc1000: remove unnecessary 'out of memory' message in
    handle_key()
  staging: wilc1000: modified NULL check used for 'if' condition in
    delete_key()
  staging: wilc1000: remove unnecessary bracket used in switch in
    wilc_mgmt_frame_register()
  staging: wilc1000: fix line over 80 chars in
    remove_network_from_shadow()
  staging: wilc1000: use 'else if' condition in get_station()
  staging: wilc1000: remove unnecessary file and function header
    comments
  staging: wilc1000: rename WILC_WFI_monitor_rx to avoid uppercase for
    function name
  staging: wilc1000: rename WILC_WFI_mon_priv to avoid uppercase for
    struct name
  staging: wilc1000: rename WILC_WFI_mon_xmit to avoid uppercase for
    function name
  staging: wilc1000: rename WILC_WFI_init_mon_interface to avoid
    uppercase in function name
  staging: wilc1000: rename WILC_WFI_deinit_mon_interface to avoid
    uppercase for function name
  staging: wilc1000: remove static variable 'del_beacon' and null check
  staging: wilc1000: remove the use of cur_byte variable in functions
  staging: wilc1000: remove unused macros in host_interface
  staging: wilc1000: remove unnecessary static function defination in
    wilc_spi
  staging: wilc1000: remove unnecessary header file inclusion for wilc
  staging: wilc1000: move macro after the #include file in
    wilc_wfi_netdevice
  staging: wilc1000: use is_broadcast_ether_addr check for broadcast
    address
  staging: wilc1000: rename 'during_ip_time' macro to have uppercase
    name for macro
  staging: wilc1000: rename WILC_WFI_band_2ghz variable to avoid
    mixedcase

 drivers/staging/wilc1000/coreconfigurator.c       |  5 +-
 drivers/staging/wilc1000/coreconfigurator.h       | 10 ----
 drivers/staging/wilc1000/host_interface.c         | 34 ++----------
 drivers/staging/wilc1000/linux_mon.c              | 65 ++++-------------------
 drivers/staging/wilc1000/linux_wlan.c             | 58 +++++++-------------
 drivers/staging/wilc1000/wilc_debugfs.c           |  2 -
 drivers/staging/wilc1000/wilc_sdio.c              | 10 +---
 drivers/staging/wilc1000/wilc_spi.c               | 15 ------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 58 +++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 15 ++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 48 ++++-------------
 drivers/staging/wilc1000/wilc_wlan.c              |  3 --
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  1 -
 13 files changed, 75 insertions(+), 249 deletions(-)

-- 
2.7.4
