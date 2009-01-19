Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:5104 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065AbZASL5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 06:57:04 -0500
Received: by ey-out-2122.google.com with SMTP id 22so496926eye.37
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 03:57:01 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 19 Jan 2009 13:50:37 +0200
Message-ID: <eb3ff54b0901190350o7f43e8b9w6c944779484170f6@mail.gmail.com> (sfid-20090119_125709_449239_37273D39)
Subject: [PATCH 3/4] mac80211: trivial documentation fix (mesh_nexthop_lookup()).
From: Rami Rosen <ramirose@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	luisca@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the documentation of mesh_nexthop_lookup() in mesh_hwmp.c.

Signed-off-by: Rami Rosen <ramirose@gmail.com>

--
(wireless-testing)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 3f1785c..4f862b2 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -759,7 +759,7 @@ enddiscovery:
 }

 /**
- * ieee80211s_lookup_nexthop - put the appropriate next hop on a mesh frame
+ * mesh_nexthop_lookup - put the appropriate next hop on a mesh frame
  *
  * @skb: 802.11 frame to be sent
  * @sdata: network subif the frame will be sent through
