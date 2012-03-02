Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:58468 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759310Ab2CBU1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 15:27:06 -0500
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 35FD51AF
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 20:27:05 +0000 (GMT)
Received: from relay2.stm.gmessaging.net (unknown [10.230.100.18])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id E67E12A01
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 20:27:04 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay2.stm.gmessaging.net (Postfix) with ESMTPS id 339D0A8065
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 21:26:57 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCHv2 20/21] cw1200: Credits
Date: Fri, 2 Mar 2012 21:26:42 +0100
Message-ID: <1330720003-15866-21-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_212739_315899_F53F082A)
In-Reply-To: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit>
 <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just want to say thank you to all the people contributing to the driver code.
        - Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
        - Janusz Dziedzic <janusz.dziedzic@tieto.com>
        - Bartosz Markowski <bartosz.markowski@tieto.com>
        - Amit Shakya <amit.shakya@stericsson.com>
        - Ajitpal Singh <ajitpal.singh@stericsson.com>
        - Vitaly Wool <vitaly.wool@sonyericsson.com>
        - Marek Kwaczynski <marek.kwaczynski@tieto.com>
        - Piotr Nakraszewicz <piotr.nakraszewicz@tieto.com>
        - Stefan Nilsson <stefan.xk.nilsson@stericsson.com>
        - Szymon Bigos <szymon.bigos@tieto.com>
        - Ulf Hansson <ulf.hansson@stericsson.com>
        - Michal Kazior <michal.kazior@tieto.com>
        - Philippe Langlais <philippe.langlais@linaro.org>
        - Tomasz Hliwiak <tomasz.hliwiak@tieto.com>
        - Pawel Kulakowski <pawel.kulakowski@tieto.com>

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 drivers/net/wireless/cw1200/CREDITS |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/cw1200/CREDITS

diff --git a/drivers/net/wireless/cw1200/CREDITS b/drivers/net/wireless/cw1200/CREDITS
new file mode 100644
index 0000000..d554e49
--- /dev/null
+++ b/drivers/net/wireless/cw1200/CREDITS
@@ -0,0 +1,20 @@
+History of the cw1200 driver can be found in Igloo kernel git:
+	http://www.igloocommunity.org/gitweb/?p=kernel/igloo-kernel.git;a=summary
+
+Thank you all who have contributed to the driver code:
+	- Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+	- Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
+	- Janusz Dziedzic <janusz.dziedzic@tieto.com>
+	- Bartosz Markowski <bartosz.markowski@tieto.com>
+	- Amit Shakya <amit.shakya@stericsson.com>
+	- Ajitpal Singh <ajitpal.singh@stericsson.com>
+	- Vitaly Wool <vitaly.wool@sonyericsson.com>
+	- Marek Kwaczynski <marek.kwaczynski@tieto.com>
+	- Piotr Nakraszewicz <piotr.nakraszewicz@tieto.com>
+	- Stefan Nilsson <stefan.xk.nilsson@stericsson.com>
+	- Szymon Bigos <szymon.bigos@tieto.com>
+	- Ulf Hansson <ulf.hansson@stericsson.com>
+	- Michal Kazior <michal.kazior@tieto.com>
+	- Philippe Langlais <philippe.langlais@linaro.org>
+	- Tomasz Hliwiak <tomasz.hliwiak@tieto.com>
+	- Pawel Kulakowski <pawel.kulakowski@tieto.com>
-- 
1.7.9

