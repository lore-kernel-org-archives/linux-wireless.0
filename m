Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:44770 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbcEVJGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2016 05:06:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 33/54] MAINTAINERS: Add file patterns for wireless device tree bindings
Date: Sun, 22 May 2016 11:06:10 +0200
Message-Id: <1463907991-7916-34-git-send-email-geert@linux-m68k.org> (sfid-20160522_111720_591638_8E850C86)
In-Reply-To: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
References: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Submitters of device tree binding documentation may forget to CC
the subsystem maintainer if this is missing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
Please apply this patch directly if you want to be involved in device
tree binding documentation for your subsystem.
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a9f1138131afcf1..604d5d4230406094 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8023,6 +8023,7 @@ Q:	http://patchwork.kernel.org/project/linux-wireless/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/wireless/
 F:	drivers/net/wireless/
 
 NETXEN (1/10) GbE SUPPORT
-- 
1.9.1

