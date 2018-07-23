Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728295AbeGWUrj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 16:47:39 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Linux-Audit Mailing List <linux-audit@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH v2] rfkill: fix spelling mistake contidion to condition
Date: Mon, 23 Jul 2018 15:41:38 -0400
Message-Id: <d20eb29b5ab96608af9e68ba219f15c3bdc080b4.1532369437.git.rgb@redhat.com> (sfid-20180723_214458_228392_98E99EE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This came about while trying to determine if there would be any pattern
match on contid, a new audit container identifier internal variable.
This was the only one.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/rfkill/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index a7a4e6f..3aab053 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -508,8 +508,8 @@ void rfkill_remove_epo_lock(void)
 /**
  * rfkill_is_epo_lock_active - returns true EPO is active
  *
- * Returns 0 (false) if there is NOT an active EPO contidion,
- * and 1 (true) if there is an active EPO contition, which
+ * Returns 0 (false) if there is NOT an active EPO condition,
+ * and 1 (true) if there is an active EPO condition, which
  * locks all radios in one of the BLOCKED states.
  *
  * Can be called in atomic context.
-- 
1.8.3.1
