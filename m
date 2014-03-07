Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62202 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaCGW24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 17:28:56 -0500
Received: by mail-pa0-f47.google.com with SMTP id lj1so4724528pab.6
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 14:28:56 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH] iw: embrace the Developer Certificate of Origin for contributions
Date: Fri,  7 Mar 2014 14:28:50 -0800
Message-Id: <1394231330-4215-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140307_232900_461629_A39E0717)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The Linux kernel started to embrace a light weight development contribution
agreement process called the Developer Certificate of Origin (DCO) circa
2004. Attorneys all over the planet have conferred a lot of respect and
appreciation for this document and it provides a light weight alternative to
cumbersome and controversial Contribution License Agreements (CLAs).

Similar to streamlining FOSS licenses we also all stand to gain from
streamlining a light weight contribution agreement process for development
and in light of this the the Linux Foundation recently has made the DCO a
standalone project [0] so that any FOSS project under any FOSS license can
take advantage of the same gains. The motivation and intent is documented
only currently on my blog post [1].

Lets take advantage of the new shiny DCO and embrace it for contributions.

[0] http://developercertificate.org/
[1] http://www.do-not-panic.com/2014/02/developer-certificate-of-origin.html

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
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
1.9.0

