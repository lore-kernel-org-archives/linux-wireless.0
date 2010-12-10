Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:56649 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752853Ab0LJUFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 15:05:21 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 722A9418D8
	for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 14:59:51 -0500 (EST)
Subject: Compat-wireless release for 2010-12-10 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101210200519.AF34540F97@repository3.orbit-lab.org>
Date: Fri, 10 Dec 2010 15:05:19 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   b2c2e68..2852e12  linux-2.6.37.y -> origin/linux-2.6.37.y
   4a59d8a..f9f0812  master     -> origin/master
 * [new tag]         compat-wireless-2010-12-09 -> compat-wireless-2010-12-09
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   464643e..d31ffbc  history    -> origin/history
 + df9e9ad...1b1497f master     -> origin/master  (forced update)
 * [new tag]         next-20101210 -> next-20101210
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap/Makefile: No such file or directory
make[4]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap/Makefile'.  Stop.
make[3]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap] Error 2
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2

compat-wireless code metrics

    752676 - Total upstream lines of code being pulled
      2198 - backport code changes
      1935 - backport code additions
       263 - backport code deletions
      6637 - backport from compat module
      8835 - total backport code
    1.1738 - % of code consists of backport work
      1532 - Crap changes not yet posted
      1489 - Crap additions not yet posted
        43 - Crap deletions not yet posted
    0.2035 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101210
compat-wireless release: compat-wireless-2010-12-09-pc
