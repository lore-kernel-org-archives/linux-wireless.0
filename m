Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55099 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751154AbdFAD1j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 23:27:39 -0400
From: "Tobin C. Harding" <me@tobin.cc>
To: linux-wireless@vger.kernel.org
Cc: "Tobin C. Harding" <me@tobin.cc>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Tycho Andersen <tycho@tycho.ws>
Subject: [RFC 3/3] MAINTAINERS: add maintainer entry for ks7010
Date: Thu,  1 Jun 2017 13:27:08 +1000
Message-Id: <1496287628-16787-4-git-send-email-me@tobin.cc> (sfid-20170601_052809_223286_4EA4DBF5)
In-Reply-To: <1496287628-16787-1-git-send-email-me@tobin.cc>
References: <1496287628-16787-1-git-send-email-me@tobin.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver ks7010 does not currently have a maintainer.

Add maintainers entry for ks7010.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9e98464..75250ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7429,6 +7429,13 @@ F:	Documentation/auxdisplay/ks0108
 F:	drivers/auxdisplay/ks0108.c
 F:	include/linux/ks0108.h
 
+KS7010 KEYSTREAM DRIVER
+M:      Tobin Harding <me@tobin.cc>
+L:      driverdev-devel@linuxdriverproject.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
+S:      Maintained
+F:      drivers/staging/ks7010/
+
 L3MDEV
 M:	David Ahern <dsa@cumulusnetworks.com>
 L:	netdev@vger.kernel.org
-- 
2.7.4
