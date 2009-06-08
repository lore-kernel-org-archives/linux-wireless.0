Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f187.google.com ([209.85.216.187]:53348 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZFHGI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 02:08:27 -0400
Received: by pxi17 with SMTP id 17so213970pxi.33
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 23:08:29 -0700 (PDT)
Message-ID: <4A2CA95B.2050605@gmail.com>
Date: Mon, 08 Jun 2009 16:02:03 +1000
From: Julian Calaby <julian.calaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] compat-wireless: Add entry for master-tag in .gitignore
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

master-tag wasn't mentioned in .gitignore, despite it being manufactured by
scripts/admin-update.sh.

Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 6b78bab..b6a26d3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -4,6 +4,7 @@ net
 *~
 git-describe
 compat-release
+master-tag
 .compat_autoconf*
 .config.md5
 .config.mk_md5sum.txt
