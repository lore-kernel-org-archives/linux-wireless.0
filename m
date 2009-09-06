Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1034 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758080AbZIFR7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2009 13:59:09 -0400
Subject: [PATCH] MAINTAINERS: Add Atheros Linux wireless drivers home page
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
	Len Widra <Len.Widra@atheros.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Werner Almesberger <werner@openmoko.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>, Greg KH <greg@kroah.com>,
	rshlinux@gmail.com, b_yogesh_snowy@yahoo.com,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Paul Fertser <fercerpav@gmail.com>,
	Harald Welte <laforge@openmoko.org>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <43e72e890909031554v1343bcfdu8ed6e23d0b1df832@mail.gmail.com>
References: <43e72e890909031554v1343bcfdu8ed6e23d0b1df832@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 10:59:10 -0700
Message-Id: <1252259950.9660.179.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-09-03 at 15:54 -0700, Luis R. Rodriguez wrote:
> I'm pleased to announce the new home page to Atheros Linux wireless drivers:
> http://wireless.kernel.org/en/users/Drivers/Atheros

Perhaps add this to MAINTAINERS?

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8dca9d8..de922cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -876,6 +876,7 @@ M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
 M:	Bob Copeland <me@bobcopeland.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath5k-devel@lists.ath5k.org
+W:	http://wireless.kernel.org/en/users/Drivers/Atheros
 S:	Maintained
 F:	drivers/net/wireless/ath/ath5k/
 
@@ -887,12 +888,14 @@ M:	Vasanthakumar Thiagarajan <vasanth@atheros.com>
 M:	Senthil Balasubramanian <senthilkumar@atheros.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath9k-devel@lists.ath9k.org
+W:	http://wireless.kernel.org/en/users/Drivers/Atheros
 S:	Supported
 F:	drivers/net/wireless/ath/ath9k/
 
 ATHEROS AR9170 WIRELESS DRIVER
 M:	Christian Lamparter <chunkeey@web.de>
 L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org/en/users/Drivers/Atheros
 W:	http://wireless.kernel.org/en/users/Drivers/ar9170
 S:	Maintained
 F:	drivers/net/wireless/ath/ar9170/



