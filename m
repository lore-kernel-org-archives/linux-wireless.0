Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:55650 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbXFXJC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2007 05:02:29 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id DDBD28CBE1
	for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2007 11:02:25 +0200 (CEST)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id D975314548
	for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2007 09:03:10 +0000 (UTC)
Message-Id: <20070624090145.041930029@warmcat.com>
References: <20070624085757.244871712@warmcat.com>
Date: Sun, 24 Jun 2007 09:58:00 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH Try#14 3/4] --- include/linux/if_ether.h | 1 + 1 file changed, 1 insertion(+)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Index: wireless-dev/include/linux/if_ether.h
===================================================================
--- wireless-dev.orig/include/linux/if_ether.h
+++ wireless-dev/include/linux/if_ether.h
@@ -98,6 +98,7 @@
 #define ETH_P_ECONET	0x0018		/* Acorn Econet			*/
 #define ETH_P_HDLC	0x0019		/* HDLC frames			*/
 #define ETH_P_ARCNET	0x001A		/* 1A for ArcNet :-)            */
+#define ETH_P_80211_RT	0x001B		/* Radiotap + 80211 encapsulation */
 
 /*
  *	This is an Ethernet frame header.

-- 
