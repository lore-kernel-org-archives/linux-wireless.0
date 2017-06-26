Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:63467 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdFZLoj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 07:44:39 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <Ganesh.Krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH v2 0/8] Enable access category classification on Tx path
Date: Mon, 26 Jun 2017 17:13:22 +0530
Message-ID: <1498477410-19518-1-git-send-email-aditya.shankar@microchip.com> (sfid-20170626_134448_819188_309E611A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds changes made to implement access
category based data classification and manages buffers allocation
between different access categories on the Tx path.

Aditya Shankar (8):
  staging: wilc1000: Add support for AC classification.
  staging: wilc1000: Add function to calculate ac queue limit
  staging: wilc1000: WMM classification of data
  staging: wilc1000: Add function to balance packet count
  staging: wilc1000: Add new variable for ac queue management
  staging: wilc1000: Get packet count from firmware
  staging: wilc1000: Change ac based on acm status
  staging: wilc1000: Update ACM bit status

Change in v2:
Add a missing patch in the patchset

 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   1 +
 drivers/staging/wilc1000/wilc_wlan.c          | 136 ++++++++++++++++++++++++++
 drivers/staging/wilc1000/wilc_wlan.h          |  25 +++++
 3 files changed, 162 insertions(+)

-- 
2.7.4
