Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:55685 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2CMMiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 08:38:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: [PATCH] ath6kl: fix debug.c file mode
Date: Tue, 13 Mar 2012 14:38:45 +0200
Message-Id: <1331642325-27729-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120313_133855_127852_BB2B72FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 7504a3e1 ("ath6kl: add padding to firmware log records") accidentally
changed debug.c mode from 100644 to 100755. Revert that back to original.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 drivers/net/wireless/ath/ath6kl/debug.c

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
old mode 100755
new mode 100644
-- 
1.7.1

