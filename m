Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:51201 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938592AbeBUQMT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 11:12:19 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/4] staging: wilc1000: modify functions by making use of GENMASK macro 
Date: Wed, 21 Feb 2018 21:42:08 +0530
Message-ID: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180221_171247_855210_D3BB0CF8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains changes to refactor functions by making use of
GENMASK macro and also removed unnecessary variable from
wilc_spi_read_int().

Ajay Singh (4):
  staging: wilc1000: remove use of 'happened' variable in
    wilc_spi_read_int()
  staging: wilc1000: modified wilc_spi_read_int() by using GENMASK macro
  staging: wilc1000: refactor wilc_spi_clear_int_ext() by using GENMASK
    macro
  staging: wilc1000: refactor sdio_clear_int_ext() by using GENMASK
    macro

 drivers/staging/wilc1000/wilc_sdio.c | 74 +++++++++++++++---------------------
 drivers/staging/wilc1000/wilc_spi.c  | 57 +++++++++++----------------
 2 files changed, 53 insertions(+), 78 deletions(-)

-- 
2.7.4
