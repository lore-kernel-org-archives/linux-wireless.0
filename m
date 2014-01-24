Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43247 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaAXWVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:21:11 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so3622776pde.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 14:21:11 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] crda: document contribution process using the DCO
Date: Fri, 24 Jan 2014 14:21:04 -0800
Message-Id: <1390602064-26043-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140124_232116_206283_3B512F7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This documents the contribution process for CRDA, which makes
use of the Developer Certificate of Origin:

http://developercertificate.org/

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 CONTRIBUTING | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 CONTRIBUTING

diff --git a/CONTRIBUTING b/CONTRIBUTING
new file mode 100644
index 0000000..f288959
--- /dev/null
+++ b/CONTRIBUTING
@@ -0,0 +1,49 @@
+
+This project embraces the Developer Certificate of Origin (DCO) for
+contributions. This means you must agree to the following prior to submitting
+patches, if you agree with this developer certificate you acknowledge this by
+adding a Signed-off-by tag to your patch commit log. Every submitted patch
+must have this.
+
+The source for the DCO:
+
+http://developercertificate.org/
+
+-----------------------------------------------------------------------
+
+Developer Certificate of Origin
+Version 1.1
+
+Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
+660 York Street, Suite 102,
+San Francisco, CA 94110 USA
+
+Everyone is permitted to copy and distribute verbatim copies of this
+license document, but changing it is not allowed.
+
+
+Developer's Certificate of Origin 1.1
+
+By making a contribution to this project, I certify that:
+
+(a) The contribution was created in whole or in part by me and I
+    have the right to submit it under the open source license
+    indicated in the file; or
+
+(b) The contribution is based upon previous work that, to the best
+    of my knowledge, is covered under an appropriate open source
+    license and I have the right under that license to submit that
+    work with modifications, whether created in whole or in part
+    by me, under the same open source license (unless I am
+    permitted to submit under a different license), as indicated
+    in the file; or
+
+(c) The contribution was provided directly to me by some other
+    person who certified (a), (b) or (c) and I have not modified
+    it.
+
+(d) I understand and agree that this project and the contribution
+    are public and that a record of the contribution (including all
+    personal information I submit with it, including my sign-off) is
+    maintained indefinitely and may be redistributed consistent with
+    this project or the open source license(s) involved.
-- 
1.8.5.2

