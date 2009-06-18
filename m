Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1515 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbZFRSIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 14:08:06 -0400
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] MAINTAINERS: Update wireless.h path
Date: Thu, 18 Jun 2009 11:08:03 -0700
Message-Id: <ffaddefd935f7be6c96abc56066ae853a8399238.1245345515.git.joe@perches.com>
In-Reply-To: <cover.1245345515.git.joe@perches.com>
References: <cover.1245345515.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d9b3665..f4175c5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4084,7 +4084,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 F:	net/wireless/
 F:	include/net/ieee80211*
-F:	include/net/wireless.h
+F:	include/linux/wireless.h
 
 NETWORKING DRIVERS
 L:	netdev@vger.kernel.org
-- 
1.6.3.1.10.g659a0.dirty

