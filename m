Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:36176 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdBXFez (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 00:34:55 -0500
Date: Fri, 24 Feb 2017 00:34:52 -0500
From: Tahia Khan <tahia.khan@gmail.com>
To: outreachy-kernel@googlegroups.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] staging: wilc1000: multiple coding style changes to
 struct tstrRSSI
Message-ID: <cover.1487912400.git.tahia.khan@gmail.com> (sfid-20170224_063503_778005_D4A79EB4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multiple coding style changes to struct tstrRSSI. Initially reported by checkpath.pl:

Avoid CamelCase: <tstrRSSI>
Avoid CamelCase: <u8Full>
Avoid CamelCase: <u8Index>

Changes since v2: Renaming tstrRSSI and members with more descriptive names, 
    as suggested by Arend Van Spriel <arend.vanspriel@broadcom.com>

Tahia Khan (3):
  staging: wilc1000: Rename struct tstrRSSI to rssi_history_buffer for
    clarity and to remove camel casing.
  staging: wilc1000: Remove Hungarian notation and camel casing from all
    tstrRSSI members’ names. Additionally, change type of u8Full to bool
    since it only takes values 1 or 0.
  staging: wilc1000: Change name of str_rssi to rssi_history within the
    network_info struct for clarity.

 drivers/staging/wilc1000/coreconfigurator.h       | 10 +++++-----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
 2 files changed, 12 insertions(+), 12 deletions(-)

-- 
2.7.4
