Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:2140 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXJIM37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 08:29:59 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: remove one superfluous include
Date: Tue, 9 Oct 2007 14:30:10 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710091430.11043.hs4233@mail.mn-solutions.de> (sfid-20071009_133006_261821_4CAD6C7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes scripts/checkincludes.pl happy.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: libertas-2.6/drivers/net/wireless/libertas/if_usb.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/if_usb.c	2007-10-09 15:29:38.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/if_usb.c	2007-10-09 15:29:59.000000000 +0200
@@ -15,7 +15,6 @@
 #include "defs.h"
 #include "dev.h"
 #include "if_usb.h"
-#include "decl.h"
 
 #define MESSAGE_HEADER_LEN	4
 
