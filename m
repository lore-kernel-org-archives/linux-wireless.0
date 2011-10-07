Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63518 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1JGJxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 05:53:45 -0400
Received: by eyg7 with SMTP id 7so932071eyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 02:53:44 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Update injection documentation
Date: Fri,  7 Oct 2011 11:53:41 +0200
Message-Id: <1317981221-12958-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111007_115349_483155_4A479FC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation about NOACK tx flag usage.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 Documentation/networking/mac80211-injection.txt |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/networking/mac80211-injection.txt b/Documentation/networking/mac80211-injection.txt
index b30e81a..3a93007 100644
--- a/Documentation/networking/mac80211-injection.txt
+++ b/Documentation/networking/mac80211-injection.txt
@@ -23,6 +23,10 @@ radiotap headers and used to control injection:
    IEEE80211_RADIOTAP_F_FRAG: frame will be fragmented if longer than the
 			      current fragmentation threshold.
 
+ * IEEE80211_RADIOTAP_TX_FLAGS
+
+   IEEE80211_RADIOTAP_F_TX_NOACK: frame should be sent without waiting for
+				  an ACK even if it is a unicast frame
 
 The injection code can also skip all other currently defined radiotap fields
 facilitating replay of captured radiotap headers directly.
-- 
1.7.3.4

