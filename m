Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sflc.info ([216.27.154.199]:39409 "EHLO mail.sflc.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759456AbXI0Xeq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 19:34:46 -0400
From: "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: "Matt Norwood" <norwood@softwarefreedom.org>,
	<fontana@softwarefreedom.org>, <karen@softwarefreedom.org>,
	<mentor@madwifi.org>, <mcgrof@winlab.rutgers.edu>,
	<proski@gnu.org>, <jirislaby@gmail.com>
Subject: [PATCH] ath5k: final correction of copyright notices
References: <43e72e890709180944r1ba08e23n78a533f403b42c00@mail.gmail.com>
	<20070918170739.GB4940@tuxdriver.com>
	<43e72e890709181109la8ad972y2e3dbbcb56550a7@mail.gmail.com>
	<20070918182128.GC4940@tuxdriver.com>
	<43e72e890709181217i57aee950o177ed6e988cf8c19@mail.gmail.com>
	<20070918193423.GG4940@tuxdriver.com>
	<43e72e890709181324r58a24f61wf4e1de518b8bd47e@mail.gmail.com>
Date: Thu, 27 Sep 2007 18:58:24 -0400
In-Reply-To: <43e72e890709181324r58a24f61wf4e1de518b8bd47e@mail.gmail.com> (Luis R. Rodriguez's message of "Tue\, 18 Sep 2007 16\:24\:13 -0400")
Message-ID: <87ejgj4sxb.fsf_-_@ebb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch below is for application to the wireless-2.6 ath5k branch, and
takes into account the latest driver directory move and file renames.  I
believe this patch handles all copyright notice issues that SFLC is
currently aware of.  Based on our extensive research (which is summarized
in http://www.softwarefreedom.org/resources/2007/ath5k-code-analysis.html)
we found that the copyright holders below also have a copyright on some
files; the patch below adds their copyright notices.

We encourage future patchers to add their copyright notice (and any
appropriate additional licensing notices as needed) into the files when
they make patches.  We also refer developers to our paper at
http://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html
that recommends ways to incorporate permissive-licensed code like this in
a GPL-licensed project like Linux.

We at SFLC were all very happy to do this work for the Linux Wireless team
and are glad that a favorable outcome for all was reached.


I believe I've used all the patch-submission tags correctly based on
previous discussions and email exchanges with everyone involved, but I
obviously don't patch the kernel often (er, at all :), so if I've made a
mistake, please let me know.

 
Changes-licensed-under: ISC
Signed-off-by: Richard Fontana <fontana@softwarefreedom.org>
Signed-off-by: Bradley M. Kuhn <bkuhn@softwarefreedom.org>
Signed-off-by: Matt Norwood <norwood@softwarefreedom.org>
Signed-off-by: Karen Sandler <karen@softwarefreedom.org>
Acked-by: Matthew W. S. Bell  <mentor@madwifi.org>
Acked-by: Pavel Roskin <proski@gnu.org>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Luis Rodriguez <mcgrof@winlab.rutgers.edu>
Acked-by: Michael Taylor <mike.taylor@apprion.com>
---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index a392315..ae4c5b5 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -1,6 +1,9 @@
  /*
  * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
  * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
+ * Copyright (c) 2007 Matthew W. S. Bell  <mentor@madwifi.org>
+ * Copyright (c) 2007 Luis Rodriguez <mcgrof@winlab.rutgers.edu>
+ * Copyright (c) 2007 Pavel Roskin <proski@gnu.org>
  * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
  *
  * Permission to use, copy, modify, and distribute this software for any
diff --git a/drivers/net/wireless/ath5k/hw.h b/drivers/net/wireless/ath5k/hw.h
index 55ae849..d48754c 100644
--- a/drivers/net/wireless/ath5k/hw.h
+++ b/drivers/net/wireless/ath5k/hw.h
@@ -1,6 +1,8 @@
 /*
  * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
  * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
+ * Copyright (c) 2007 Matthew W. S. Bell  <mentor@madwifi.org>
+ * Copyright (c) 2007 Luis Rodriguez <mcgrof@winlab.rutgers.edu>
  *
  * Permission to use, copy, modify, and distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index d4a8b7b..0a7b312 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2007 Nick Kossifidis <mickflemm@gmail.com>
  * Copyright (c) 2004, 2005, 2006, 2007 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2007 Michael Taylor <mike.taylor@apprion.com>
  *
  * Permission to use, copy, modify, and distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
