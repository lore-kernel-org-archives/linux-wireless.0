Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752989AbeBSPaH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:07 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/14] staging: wilc1000: fix to avoid cameCase & unnecessary parentheses
Date: Mon, 19 Feb 2018 20:59:30 +0530
Message-ID: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163109_744558_DF2A878E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series removes the issues found by checkpatch.pl script
in host_interface.c/.h file.

Ajay Singh (14):
  staging: wilc1000: rename s8PowerMode & strPowerMgmtParam to avoid
    camelCase
  staging: wilc1000: rename strHostIfSetMulti to avoid camelCase
  staging: wilc1000: rename host_int_get_assoc_res_info() parameters to
    avoid camelCase
  staging: wilc1000: rename pstrHostIfRemainOnChan to avoid camelCase
  staging: wilc1000: rename pstrHostIfRegisterFrame to avoid camelCase
  staging: wilc1000: rename strHostIfStaInactiveT to avoid camelCase
  staging: wilc1000: rename pstrRcvdGnrlAsyncInfo to avoid camelCase
  staging: wilc1000: rename pstrRcvdNetworkInfo to avoid camelCase
  staging: wilc1000: rename functions starting with Handle_ to avoid
    camelCase
  staging: wilc1000: rename functions starting with TimerCB_ to avoid
    camelCase
  staging: wilc1000: rename ListenTimerCB to avoid camelCase
  staging: wilc1000: rename GetPeriodicRSSI to avoid camelCase
  staging: wilc1000: rename wilc_remove_key() parameters to avoid
    camelCase
  staging: wilc1000: remove Unnecessary parentheses around
    'hif_set_mc->cnt'

 drivers/staging/wilc1000/host_interface.c | 220 +++++++++++++++---------------
 drivers/staging/wilc1000/host_interface.h |   2 +-
 2 files changed, 111 insertions(+), 111 deletions(-)

-- 
2.7.4
