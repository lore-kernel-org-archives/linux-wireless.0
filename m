Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56652 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbeEAJgt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 05:36:49 -0400
From: Colin King <colin.king@canonical.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: ipw2200:  fix spelling mistake: "functionalitis" -> "functionalities"
Date: Tue,  1 May 2018 10:36:43 +0100
Message-Id: <20180501093643.23318-1-colin.king@canonical.com> (sfid-20180501_113706_836113_4A6EA266)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in module parameter description text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 87a5e414c2f7..ba3fb1d2ddb4 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -12012,7 +12012,7 @@ MODULE_PARM_DESC(rtap_iface, "create the rtap interface (1 - create, default 0)"
 
 #ifdef CONFIG_IPW2200_QOS
 module_param(qos_enable, int, 0444);
-MODULE_PARM_DESC(qos_enable, "enable all QoS functionalitis");
+MODULE_PARM_DESC(qos_enable, "enable all QoS functionalities");
 
 module_param(qos_burst_enable, int, 0444);
 MODULE_PARM_DESC(qos_burst_enable, "enable QoS burst mode");
-- 
2.17.0
