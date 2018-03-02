Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:48233 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424959AbeCBOXQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:23:16 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/13] staging: wilc1000: fix camelcase,line over 80 char and few smatch warning
Date: Fri, 2 Mar 2018 19:52:36 +0530
Message-ID: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_152320_770689_9531F675)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains fixes for checkpatch.pl reported issue & 'always true
condition' smatch warning.


Ajay Singh (13):
  staging: wilc1000: rename enuEvent to avoid camelCase
  staging: wilc1000: remove always 'true' check from 'if' statement
  staging: wilc1000: fix line over 80 char in handle_cfg_param()
  staging: wilc1000: fix line over 80 char in
    wilc_network_info_received()
  staging: wilc1000: fix line over 80 char for
    wilc_gnrl_async_info_received()
  staging: wilc1000: fix line over 80 char in
    host_int_parse_join_bss_param()
  staging: wilc1000: rename pstrHostIFkeyAttr to avoid camelCase issue
  staging: wilc1000: fix line over 80 char in wilc_add_ptk()
  staging: wilc1000: fix line over 80 char in wilc_del_allstation() &
    wilc_deinit()
  staging: wilc1000: fix line over 80 char in
    wilc_scan_complete_received()
  staging: wilc1000: rename handle_connect_timeout() variables to avoid
    camelCase
  staging: wilc1000: fix line over 80 char in handle_rcvd_ntwrk_info()
  staging: wilc1000: rename u16DummyReasonCode to avoid camelCase

 drivers/staging/wilc1000/host_interface.c | 644 ++++++++++++++++--------------
 1 file changed, 335 insertions(+), 309 deletions(-)

-- 
2.7.4
