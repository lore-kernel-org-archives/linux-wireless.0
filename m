Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35468 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760474Ab0HENwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 09:52:24 -0400
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: gelma@gelma.net
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Tejun Heo <tj@kernel.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 11/15] net: mac80211: Fix a typo.
Date: Thu,  5 Aug 2010 15:51:35 +0200
Message-Id: <1281016299-23958-11-git-send-email-andrea.gelmini@gelma.net>
In-Reply-To: <1281016299-23958-1-git-send-email-andrea.gelmini@gelma.net>
References: <1281016299-23958-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"userpace" -> "userspace"

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 net/mac80211/rc80211_pid_debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_pid_debugfs.c b/net/mac80211/rc80211_pid_debugfs.c
index 47438b4..135f36f 100644
--- a/net/mac80211/rc80211_pid_debugfs.c
+++ b/net/mac80211/rc80211_pid_debugfs.c
@@ -162,7 +162,7 @@ static ssize_t rate_control_pid_events_read(struct file *file, char __user *buf,
 	file_info->next_entry = (file_info->next_entry + 1) %
 				RC_PID_EVENT_RING_SIZE;
 
-	/* Print information about the event. Note that userpace needs to
+	/* Print information about the event. Note that userspace needs to
 	 * provide large enough buffers. */
 	length = length < RC_PID_PRINT_BUF_SIZE ?
 		 length : RC_PID_PRINT_BUF_SIZE;
-- 
1.7.2.1.85.g2d089

