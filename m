Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:3135 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752396AbeBPPL4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:11:56 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/12] fix to remove line over 80 chars and few other
Date: Fri, 16 Feb 2018 20:41:37 +0530
Message-ID: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161203_820005_C08DF79E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains changes to fix line over 80 characters,
too many leading tabs and few other issues reported by checkpatch.pl
script.

Ajay Singh (12):
  staging: wilc1000: remove unnecessary comments to avoid line over 80
    char issue
  staging: wilc1000: fix too many leading tabs warning in
    sdio_clear_int_ext()
  staging: wilc1000: fix line over 80 characters in sdio_clear_int_ext()
  staging: wilc1000: fix open parenthesis alignment mismatch in
    wilc_parse_network_info()
  staging: wilc1000: fix line over 80 char in wilc_wlan_cfg_set_str()
  staging: wilc1000: remove blank line before close brace in
    wilc_wlan_cfg_get_wid_value()
  staging: wilc1000: fix line over 80 chars in
    wilc_wlan_cfg_indicate_rxi()
  staging: wilc1000: fix line over 80 chars in
    wilc_wlan_cfg_get_wid_value()
  staging: wilc1000: fix line over 80 chars in add_tcp_pending_ack()
  staging: wilc1000: fix line over 80 characters in tcp_process()
  staging: wilc1000: fix line over 80 chars in
    wilc_wlan_txq_filter_dup_tcp_ack()
  staging: wilc1000: fix line over 80 chars in wilc_wlan_handle_txq()

 drivers/staging/wilc1000/coreconfigurator.c |   4 +-
 drivers/staging/wilc1000/wilc_sdio.c        | 145 ++++++++++++++--------------
 drivers/staging/wilc1000/wilc_wlan.c        |  70 +++++++++-----
 drivers/staging/wilc1000/wilc_wlan_cfg.c    |  21 ++--
 4 files changed, 134 insertions(+), 106 deletions(-)

-- 
2.7.4
