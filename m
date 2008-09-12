Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYILITV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 04:19:21 -0400
Subject: [PATCH] mac80211: clean up kdoc
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 10:18:44 +0200
Message-Id: <1221207524.11204.9.camel@johannes.berg> (sfid-20080912_101927_990762_D9C9BF0D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few errors sneaked in over time, some functions no longer exist,
for some alternatives exist. This changes the docbook template to
include the right things.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/DocBook/mac80211.tmpl |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- everything.orig/Documentation/DocBook/mac80211.tmpl	2008-09-12 10:16:51.000000000 +0200
+++ everything/Documentation/DocBook/mac80211.tmpl	2008-09-12 10:17:00.000000000 +0200
@@ -145,7 +145,6 @@ usage should require reading the full do
         this though and the recommendation to allow only a single
         interface in STA mode at first!
       </para>
-!Finclude/net/mac80211.h ieee80211_if_types
 !Finclude/net/mac80211.h ieee80211_if_init_conf
 !Finclude/net/mac80211.h ieee80211_if_conf
     </chapter>
@@ -177,8 +176,7 @@ usage should require reading the full do
         <title>functions/definitions</title>
 !Finclude/net/mac80211.h ieee80211_rx_status
 !Finclude/net/mac80211.h mac80211_rx_flags
-!Finclude/net/mac80211.h ieee80211_tx_control
-!Finclude/net/mac80211.h ieee80211_tx_status_flags
+!Finclude/net/mac80211.h ieee80211_tx_info
 !Finclude/net/mac80211.h ieee80211_rx
 !Finclude/net/mac80211.h ieee80211_rx_irqsafe
 !Finclude/net/mac80211.h ieee80211_tx_status
@@ -189,12 +187,11 @@ usage should require reading the full do
 !Finclude/net/mac80211.h ieee80211_ctstoself_duration
 !Finclude/net/mac80211.h ieee80211_generic_frame_duration
 !Finclude/net/mac80211.h ieee80211_get_hdrlen_from_skb
-!Finclude/net/mac80211.h ieee80211_get_hdrlen
+!Finclude/net/mac80211.h ieee80211_hdrlen
 !Finclude/net/mac80211.h ieee80211_wake_queue
 !Finclude/net/mac80211.h ieee80211_stop_queue
-!Finclude/net/mac80211.h ieee80211_start_queues
-!Finclude/net/mac80211.h ieee80211_stop_queues
 !Finclude/net/mac80211.h ieee80211_wake_queues
+!Finclude/net/mac80211.h ieee80211_stop_queues
       </sect1>
     </chapter>
 
@@ -230,8 +227,7 @@ usage should require reading the full do
       <title>Multiple queues and QoS support</title>
       <para>TBD</para>
 !Finclude/net/mac80211.h ieee80211_tx_queue_params
-!Finclude/net/mac80211.h ieee80211_tx_queue_stats_data
-!Finclude/net/mac80211.h ieee80211_tx_queue
+!Finclude/net/mac80211.h ieee80211_tx_queue_stats
     </chapter>
 
     <chapter id="AP">


