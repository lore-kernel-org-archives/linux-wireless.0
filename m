Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33060 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbbFOKmn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 06:42:43 -0400
Received: by pdjn11 with SMTP id n11so70370401pdj.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2015 03:42:42 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 2/2] staging: wilc1000: remove the warnings on prohibited spaces.
Date: Mon, 15 Jun 2015 19:42:32 +0900
Message-Id: <60ccb784bd44ee83b265526ffc7a334b684c017a.1434361814.git.ywhsbliss@gmail.com> (sfid-20150615_124246_153324_5E1579AE)
In-Reply-To: <f6284cd2afe7096c38741f6391d150a2c2dd198a.1434361814.git.ywhsbliss@gmail.com>
References: <f6284cd2afe7096c38741f6391d150a2c2dd198a.1434361814.git.ywhsbliss@gmail.com>
In-Reply-To: <f6284cd2afe7096c38741f6391d150a2c2dd198a.1434361814.git.ywhsbliss@gmail.com>
References: <f6284cd2afe7096c38741f6391d150a2c2dd198a.1434361814.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove space prohibited between function name and open parenthesis.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/coreconfigsimulator.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigsimulator.h b/drivers/staging/wilc1000/coreconfigsimulator.h
index c4f32f0..5e01f8e 100644
--- a/drivers/staging/wilc1000/coreconfigsimulator.h
+++ b/drivers/staging/wilc1000/coreconfigsimulator.h
@@ -11,7 +11,7 @@
 #ifndef CORECONFIGSIMULATOR_H
 #define CORECONFIGSIMULATOR_H
 
-extern s32 CoreConfigSimulatorInit (void);
-extern s32 CoreConfigSimulatorDeInit (void);
+extern s32 CoreConfigSimulatorInit(void);
+extern s32 CoreConfigSimulatorDeInit(void);
 
 #endif
-- 
1.9.1

