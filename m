Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:9462 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdJ1FGy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Oct 2017 01:06:54 -0400
From: Wei Yongjun <weiyongjun1@huawei.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
CC: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH net-next] rsi: remove unused including <linux/version.h>
Date: Sat, 28 Oct 2017 05:10:26 +0000
Message-ID: <1509167426-93439-1-git-send-email-weiyongjun1@huawei.com> (sfid-20171028_070658_627080_FCD80992)
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireless/rsi/rsi_91x_ps.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_ps.c b/drivers/net/wireless/rsi/rsi_91x_ps.c
index 523f532..410c55f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_ps.c
+++ b/drivers/net/wireless/rsi/rsi_91x_ps.c
@@ -16,7 +16,6 @@
 
 #include <linux/etherdevice.h>
 #include <linux/if.h>
-#include <linux/version.h>
 #include "rsi_debugfs.h"
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
