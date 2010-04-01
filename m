Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54188 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab0DAS7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 14:59:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] Implement IEEE =?iso-8859-1?q?802=2E11=FC?=
Date: Thu, 1 Apr 2010 19:59:35 +0100
MIME-Version: 1.0
Message-Id: <201004012059.35748.mb@bu3sch.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This patch implements IEEE 802.11ü. The official standard for German
extensions to the IEEE 802.11 wireless standard.

These extensions include:
* LHSEC (Lederhosen-security): Just barely protects the important parts.
  Leaves everything else fully exposed to the public, no matter how
  harmful it is.
* SAU (Stubborn authentication): The AP won't let you in. No matter what.
  This is an advanced security feature.
* BEER (drink-a-lot-of-beer-routing): Will route packets from STAs to randomly
  chosen APs. It will do this excessively until all APs banned the STA.
* SRAD (strict radio): This feature will open a popup window for every to be sent
  packet on the desktop. This window will contain an application form that has
  to be filled out and sent to the next administration office via snailmail. Upon
  successful approval by the administration, the packet is officially certified
  to go "on air" within a well defined timeframe.
  This is an advanced security feature.


Index: wireless-testing/net/mac80211/Kconfig
===================================================================
--- wireless-testing.orig/net/mac80211/Kconfig	2010-04-01 20:43:20.000000000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2010-04-01 20:56:29.000000000 +0200
@@ -226,3 +226,9 @@ config MAC80211_DRIVER_API_TRACER
 	  trace.
 
 	  If unsure, say N.
+
+config MAC80211_80211UE_SUPPORT
+	bool "Support for 802.11ü"
+	depends on GERMAN_PASSPORT
+	help
+	  Say Y here, if you want to enab
<CONNECTION INTERRUPTED>
