Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:37314 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424338AbeCBOR3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:17:29 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/3] staging: wilc1000: fix line over 80 char & coding style
Date: Fri, 2 Mar 2018 19:47:17 +0530
Message-ID: <1520000240-27519-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_151733_138451_3326DC5B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains fixes for open parenthesis mismatch and line
over 80 char issue found by checkpatch script.

Ajay Singh (3):
  staging: wilc1000: fix open parenthesis mismatch in
    wilc_wlan_cfg_get()
  staging: wilc1000: fix line over 80 char in wilc_wlan_cfg_set()
  staging: wilc1000: fix line over 80 char in wilc_wlan_handle_rxq()

 drivers/staging/wilc1000/wilc_wlan.c | 172 +++++++++++++++++++----------------
 1 file changed, 93 insertions(+), 79 deletions(-)

-- 
2.7.4
