Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:40407 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbYEJBMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 21:12:02 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1372626wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2008 18:12:00 -0700 (PDT)
Date: Sat, 10 May 2008 09:11:58 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: yi.zhu@intel.com, reinette.chatre@intel.com
Subject: iwl-sta.c: removed duplicated include
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Message-Id: <20080510091004.2451.WEIYI.HUANG@gmail.com> (sfid-20080510_031207_377549_3D6B6E2F)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed duplicated include "iwl-sta.h" in 
drivers/net/wireless/iwlwifi/iwl-sta.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

--- a/drivers/net/wireless/iwlwifi/iwl-sta.c    2008-05-10 08:50:32.000000000 +0800
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c    2008-05-10 08:50:46.000000000 +0800
@@ -36,7 +36,6 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 #include "iwl-4965.h"
-#include "iwl-sta.h"

 int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {

