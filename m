Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40220 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbaICT5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:12 -0400
Received: by mail-wg0-f47.google.com with SMTP id z12so8928329wgg.6
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:11 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/36] iwlwifi: add Intel Mobile Communications copyright
Date: Wed,  3 Sep 2014 22:56:16 +0300
Message-Id: <1409774184-24665-28-git-send-email-egrumbach@gmail.com> (sfid-20140903_215756_596634_20818A29)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Our legal structure changed at some point (see wikipedia), but
we forgot to immediately switch over to the new copyright
notice.

For files that we have modified in the time since the change,
add the proper copyright notice now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c          | 2 ++
 drivers/net/wireless/iwlwifi/iwl-8000.c          | 2 ++
 drivers/net/wireless/iwlwifi/iwl-csr.h           | 2 ++
 drivers/net/wireless/iwlwifi/iwl-drv.c           | 2 ++
 drivers/net/wireless/iwlwifi/iwl-drv.h           | 2 ++
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 2 ++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       | 2 ++
 drivers/net/wireless/iwlwifi/iwl-fw.h            | 2 ++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c     | 2 ++
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       | 2 ++
 drivers/net/wireless/iwlwifi/iwl-prph.h          | 2 ++
 drivers/net/wireless/iwlwifi/iwl-trans.h         | 2 ++
 drivers/net/wireless/iwlwifi/mvm/coex.c          | 2 ++
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c   | 2 ++
 drivers/net/wireless/iwlwifi/mvm/constants.h     | 2 ++
 drivers/net/wireless/iwlwifi/mvm/d3.c            | 2 ++
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c   | 2 ++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       | 2 ++
 drivers/net/wireless/iwlwifi/mvm/debugfs.h       | 2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h   | 2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h     | 2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h  | 2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h   | 2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h    | 2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h        | 2 ++
 drivers/net/wireless/iwlwifi/mvm/fw.c            | 2 ++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      | 2 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 2 ++
 drivers/net/wireless/iwlwifi/mvm/mvm.h           | 2 ++
 drivers/net/wireless/iwlwifi/mvm/nvm.c           | 2 ++
 drivers/net/wireless/iwlwifi/mvm/offloading.c    | 2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c           | 2 ++
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c      | 2 ++
 drivers/net/wireless/iwlwifi/mvm/power.c         | 2 ++
 drivers/net/wireless/iwlwifi/mvm/quota.c         | 2 ++
 drivers/net/wireless/iwlwifi/mvm/rs.c            | 1 +
 drivers/net/wireless/iwlwifi/mvm/rx.c            | 2 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c          | 2 ++
 drivers/net/wireless/iwlwifi/mvm/sf.c            | 2 ++
 drivers/net/wireless/iwlwifi/mvm/sta.c           | 2 ++
 drivers/net/wireless/iwlwifi/mvm/sta.h           | 2 ++
 drivers/net/wireless/iwlwifi/mvm/testmode.h      | 2 ++
 drivers/net/wireless/iwlwifi/mvm/time-event.c    | 2 ++
 drivers/net/wireless/iwlwifi/mvm/time-event.h    | 2 ++
 drivers/net/wireless/iwlwifi/mvm/tt.c            | 2 ++
 drivers/net/wireless/iwlwifi/mvm/tx.c            | 2 ++
 drivers/net/wireless/iwlwifi/mvm/utils.c         | 2 ++
 drivers/net/wireless/iwlwifi/pcie/drv.c          | 2 ++
 drivers/net/wireless/iwlwifi/pcie/internal.h     | 1 +
 drivers/net/wireless/iwlwifi/pcie/rx.c           | 1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c        | 2 ++
 drivers/net/wireless/iwlwifi/pcie/tx.c           | 1 +
 52 files changed, 100 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 4873006..446654a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 44b19e0..90388e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index fe129c9..23d059a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 283aee0..aefd94c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index 3c72cb7..be4f897 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index de5994a..e30a41d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 929a806..401f7be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 99e0ec4..f68cba4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 018af29..8e7af79 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 99785c8..b6d666e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 9e15273..1560f45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 7e8dc3a..c89985a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 2291bbc..2262d6d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index a3be333..585c0ab 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index ca79f71..dd00e8f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 645b3cf..607dfdb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 5f5a94b..d919b4e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index f85d4f4..d98ee10 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.h b/drivers/net/wireless/iwlwifi/mvm/debugfs.h
index e3a9774..8c4190e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
index 6987571..816883f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
index 13696fe..e74cdf2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index c3a8c86..27dd863 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index c02a9e4..8f22166 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
index 47bd040..21dd5b7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index ed7d3f3..4274f8d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 883e702..c958a7d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 0816204..7171d17 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5bc7557..cbe9ff0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index ffb5093..b66a8af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index cfdd314..4fafd4b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/offloading.c b/drivers/net/wireless/iwlwifi/mvm/offloading.c
index 9bfb95e..adcbf4c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/offloading.c
+++ b/drivers/net/wireless/iwlwifi/mvm/offloading.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 166d17c..8139adc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 6cc243f..12283b5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index b552183..e7a6626 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 300639c..5fd502d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 940e0d0..17002cf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 8f43aff..48144e3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index d01954d..bf9c63d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/sf.c b/drivers/net/wireless/iwlwifi/mvm/sf.c
index 7edfd15..d1922af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 863a536..960687b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 3b1c8bd..ea4985e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/testmode.h b/drivers/net/wireless/iwlwifi/mvm/testmode.h
index 0241665..79ab6be 100644
--- a/drivers/net/wireless/iwlwifi/mvm/testmode.h
+++ b/drivers/net/wireless/iwlwifi/mvm/testmode.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 51c610f..447d3b1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.h b/drivers/net/wireless/iwlwifi/mvm/time-event.h
index 9126379..bee3b24 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 4c22c0a..c3e1fe4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 748b169..963edb8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 20fdca4..1958f29 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index f0e722c..dbbbf23 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 163aac5..a4fedc4 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index a2698e5..702f47f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 06e04aa..3076e0e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 9fdfed8..a6336b4 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
-- 
1.9.1

