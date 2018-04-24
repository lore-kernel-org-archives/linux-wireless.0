Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:24046 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbeDXRHa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:07:30 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/2] staging: wilc1000: TODO list updates
Date: Tue, 24 Apr 2018 22:37:01 +0530
Message-ID: <1524589623-1534-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180424_190733_902176_10B438E6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Updated the TODO list by removing items, which are already addressed.
Also remove the code to handle IOCTL(SIOCSIWPRIV) as Wext support is
not present in the driver.

Ajay Singh (2):
  staging: wilc1000: remove registering of ndo_do_ioctl callback
  staging: wilc1000: updated TODO list

 drivers/staging/wilc1000/TODO         |  8 -----
 drivers/staging/wilc1000/linux_wlan.c | 63 -----------------------------------
 2 files changed, 71 deletions(-)

-- 
2.7.4
