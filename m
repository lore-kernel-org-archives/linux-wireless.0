Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:51461 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750974AbdL3VGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Dec 2017 16:06:16 -0500
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] at76c50x-usb: Adjustments for two function
 implementations
Message-ID: <1d76fe59-af15-ba4d-e05d-09dcd9ee38cd@users.sourceforge.net> (sfid-20171230_220637_920309_04BDDCAE)
Date: Sat, 30 Dec 2017 22:06:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 30 Dec 2017 22:01:23 +0100

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation in at76_submit_rx_urb()
  Improve size determinations in at76_usbdfu_download()

 drivers/net/wireless/atmel/at76c50x-usb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.15.1
