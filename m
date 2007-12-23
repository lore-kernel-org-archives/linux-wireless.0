Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:32783 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752309AbXLWDsT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 22:48:19 -0500
Date: Sun, 23 Dec 2007 04:46:27 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: [PATCH 6/7] rc80211-pid: add MAINTAINERS entry
Message-ID: <20071223044627.16ec7048@morte> (sfid-20071223_034821_482338_88389188)
In-Reply-To: <20071223033633.710907923@polimi.it>
References: <20071223033633.710907923@polimi.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add an entry in MAINTAINERS for rc80211-pid.

Cc: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: wireless-2.6/MAINTAINERS
===================================================================
--- wireless-2.6.orig/MAINTAINERS
+++ wireless-2.6/MAINTAINERS
@@ -2495,6 +2495,16 @@ W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained

+MAC80211 PID RATE CONTROL
+P:	Stefano Brivio
+M:	stefano.brivio@polimi.it
+P:	Mattias Nissler
+M:	mattias.nissler@gmx.de
+L:	linux-wireless@vger.kernel.org
+W:	http://linuxwireless.org/en/developers/Documentation/mac80211/RateControl/PID
+T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+S:	Maintained
+
 MACVLAN DRIVER
 P:	Patrick McHardy
 M:	kaber@trash.net

-- 
Ciao
Stefano
