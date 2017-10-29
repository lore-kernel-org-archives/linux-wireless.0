Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:54751 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751315AbdJ2UKv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 16:10:51 -0400
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Eyal Reizer <eyalr@ti.com>, Iain Hunter <drhunter95@gmail.com>,
        James Minor <james.minor@ni.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/5] wlcore: Fine-tuning for three function implementations
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <dc2b8a7c-b4a9-2f92-12b4-a1d0d6911d7c@users.sourceforge.net> (sfid-20171029_211107_124111_C4F29BE0)
Date: Sun, 29 Oct 2017 21:10:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 29 Oct 2017 21:02:34 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (5):
  Use common error handling code in wlcore_nvs_cb()
  Delete an unnecessary check statement in wlcore_set_beacon_template()
  Return directly after a failed ieee80211_beacon_get()
    in wlcore_set_beacon_template()
  Use common error handling code in wlcore_set_beacon_template()
  Use common error handling code in wl1271_op_suspend()

 drivers/net/wireless/ti/wlcore/main.c | 51 ++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

-- 
2.14.3
