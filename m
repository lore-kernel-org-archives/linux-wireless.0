Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:33939 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbcBHPln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 10:41:43 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCH 3/9] rfkill: Point to the correct deprecated doc location
Date: Mon,  8 Feb 2016 10:41:30 -0500
Message-Id: <1454946096-9752-4-git-send-email-jprvita@endlessm.com> (sfid-20160208_164819_870995_601AD74D)
In-Reply-To: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "claim" sysfs interface has been removed, so its documentation now
lives in the "removed" folder.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 Documentation/ABI/stable/sysfs-class-rfkill | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-rfkill b/Documentation/ABI/stable/sysfs-class-rfkill
index 097f522..e51571e 100644
--- a/Documentation/ABI/stable/sysfs-class-rfkill
+++ b/Documentation/ABI/stable/sysfs-class-rfkill
@@ -2,8 +2,10 @@ rfkill - radio frequency (RF) connector kill switch support
 
 For details to this subsystem look at Documentation/rfkill.txt.
 
-For the deprecated /sys/class/rfkill/*/state and
-/sys/class/rfkill/*/claim knobs of this interface look in
+For the deprecated /sys/class/rfkill/*/claim knobs of this interface look in
+Documentation/ABI/removed/sysfs-class-rfkill.
+
+For the deprecated /sys/class/rfkill/*/state knobs of this interface look in
 Documentation/ABI/obsolete/sysfs-class-rfkill.
 
 What: 		/sys/class/rfkill
-- 
2.5.0

