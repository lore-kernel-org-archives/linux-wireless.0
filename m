Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:19922 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030977AbeBNPOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 10:14:50 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/6] fix line over 80 char & coding style in wilc_spi.c
Date: Wed, 14 Feb 2018 16:40:09 +0530
Message-ID: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180214_161454_131189_45F16A9F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains changes to remove "fix line over 80 char"
issues found by checkpatch.pl script.
Also, few changes code changes are done to follow Linux coding style.

Ajay Singh (6):
  staging: wilc1000: modified code comments as per linux coding style
  staging: wilc1000: removed the unnecessary commented code
  staging: wilc1000: fix line over 80 characters in spi_cmd_complete()
  staging: wilc1000: fix line over 80 characters in wilc_spi_init()
  staging: wilc1000: fix line over 80 characters in wilc_spi_read_int()
  staging: wilc1000: fix line over 80 chars in wilc_spi_clear_int_ext()

 drivers/staging/wilc1000/wilc_spi.c | 551 ++++++++++++++++++------------------
 1 file changed, 278 insertions(+), 273 deletions(-)

-- 
2.7.4
