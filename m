Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35928 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaCRWJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 18:09:28 -0400
Received: by mail-pb0-f41.google.com with SMTP id jt11so7964225pbb.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 15:09:28 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>, Jouni Malinen <j@w1.fi>,
	Michael Green <green@qca.qualcomm.com>,
	Andy Davidson <adavidso@qca.qualcomm.com>
Subject: [PATCH] rel-html: add wireless-regdb project page
Date: Tue, 18 Mar 2014 15:07:14 -0700
Message-Id: <1395180434-28349-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140318_230932_528302_3DB1E34A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Since I relicensed CRDA to the copyleft-next license lets make
it crystal clear wireless-regdb is a separate project project
under the ISC license with its dedicated separate documentation
and own release page.

http://wireless.kernel.org/en/developers/Regulatory/wireless-regdb
http://drvbp1.linux-foundation.org/~mcgrof/rel-html/wireless-regdb

Cc: Jouni Malinen <j@w1.fi>
Cc: Michael Green <green@qca.qualcomm.com>
Cc: Andy Davidson <adavidso@qca.qualcomm.com>
Cc: wireless-regdb@lists.infradead.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 projects/wireless-regdb.cfg | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 projects/wireless-regdb.cfg

diff --git a/projects/wireless-regdb.cfg b/projects/wireless-regdb.cfg
new file mode 100644
index 0000000..7b14d78
--- /dev/null
+++ b/projects/wireless-regdb.cfg
@@ -0,0 +1,27 @@
+[project]
+rel_html_proj           = wireless-regdb
+supported =
+	2013.11.27
+rel_html_url_releases	= http://kernel.org/pub/software/network/wireless-regdb/
+rel_license 		= ISC
+ignore_changelogs	= True
+
+[html]
+title = wireless-regdb: Linux Wireless Regulatory Database
+
+nav_01_url = http://wireless.kernel.org/en/developers/Regulatory/wireless-regdb
+nav_01_txt = Documentation
+
+# XXX: Note: two % added here to help with what seems to be a python ConfigParser.py bug.
+#      We should address this eventually.
+nav_02_url = http://wireless.kernel.org/en/developers/Regulatory/wireless-regdb
+nav_02_txt = Bugs
+
+nav_03_url = http://lists.infradead.org/mailman/listinfo/wireless-regdb
+nav_03_txt = Mailing List
+
+release_title = Latest wireless-regdb release
+
+about_title = About wireless-regdb
+about = wireless-regdb provides the database and tools to build the database
+	read by CRDA to provide regulatory domains to the Linux kernnel.
-- 
1.8.5.3

