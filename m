Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33548C433F5
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Feb 2022 09:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352990AbiBEJV5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Feb 2022 04:21:57 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38006 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1355140AbiBEJV4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Feb 2022 04:21:56 -0500
Received: from 91-156-4-210.elisa-laajakaista.fi ([91.156.4.210] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <luca@coelho.fi>)
        id 1nGHGU-0006b7-5j;
        Sat, 05 Feb 2022 11:21:55 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@kernel.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Sat,  5 Feb 2022 11:21:40 +0200
Message-Id: <iwlwifi.20220205112029.aeec71c397b3.I0ba3234419eb8c8c7512a2ca531a6dbb55046cf7@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220205092140.751171-1-luca@coelho.fi>
References: <20220205092140.751171-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/12] iwlwifi: fix small doc mistake for iwl_fw_ini_addr_val
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

There was a small copy and paste mistake in the doc declaration of
iwl_fw_ini_addr_val.  Fix it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index 456b7eaac570..061fe6cc6cf5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2018-2021 Intel Corporation
+ * Copyright (C) 2018-2022 Intel Corporation
  */
 #ifndef __iwl_fw_dbg_tlv_h__
 #define __iwl_fw_dbg_tlv_h__
@@ -249,11 +249,10 @@ struct iwl_fw_ini_hcmd_tlv {
 } __packed; /* FW_TLV_DEBUG_HCMD_API_S_VER_1 */
 
 /**
-* struct iwl_fw_ini_conf_tlv - preset configuration TLV
+* struct iwl_fw_ini_addr_val - Address and value to set it to
 *
 * @address: the base address
 * @value: value to set at address
-
 */
 struct iwl_fw_ini_addr_val {
 	__le32 address;
-- 
2.34.1

