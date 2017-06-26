Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:59483 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdFZHEc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 03:04:32 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <linux-wireless@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <Ganesh.Krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH 0/7] Enable access category classification on Tx path
Date: Mon, 26 Jun 2017 12:33:31 +0530
Message-ID: <1498460618-22187-1-git-send-email-aditya.shankar@microchip.com> (sfid-20170626_090435_141321_A333B04B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds changes made to implement access
category based data classification and manages buffers allocation
between different access categories on the Tx path.

Aditya Shankar (7):
  staging: wilc1000: Add support for AC classification.
  staging: wilc1000: Add function to calculate ac queue limit
  staging: wilc1000: WMM classification of data
  staging: wilc1000: Add function to balance packet count
  staging: wilc1000: Get packet count from firmware
  staging: wilc1000: Change ac based on acm status
  staging: wilc1000: Update ACM bit status

 drivers/staging/wilc1000/wilc_wlan.c | 136 +++++++++++++++++++++++++++++++++++
 drivers/staging/wilc1000/wilc_wlan.h |  25 +++++++
 2 files changed, 161 insertions(+)

-- 
2.7.4
