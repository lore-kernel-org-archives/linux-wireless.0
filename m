Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbeCZFk0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:40:26 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 06/12] firmware: qcom: scm: Add WLAN VMID for Qualcomm SCM interface
Date: Mon, 26 Mar 2018 11:10:19 +0530
Message-Id: <1522042819-25916-1-git-send-email-govinds@codeaurora.org> (sfid-20180326_074029_505470_941EC49D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WLAN related VMID's to support wlan driver to set up
the remote's permissions call via TrustZone.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 include/linux/qcom_scm.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
index b401b96..da63d84 100644
--- a/include/linux/qcom_scm.h
+++ b/include/linux/qcom_scm.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010-2015, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2010-2015, 2018, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -33,6 +33,8 @@ struct qcom_scm_vmperm {
 
 #define QCOM_SCM_VMID_HLOS       0x3
 #define QCOM_SCM_VMID_MSS_MSA    0xF
+#define QCOM_SCM_VMID_WLAN       0x18
+#define QCOM_SCM_VMID_WLAN_CE    0x19
 #define QCOM_SCM_PERM_READ       0x4
 #define QCOM_SCM_PERM_WRITE      0x2
 #define QCOM_SCM_PERM_EXEC       0x1
-- 
1.9.1
