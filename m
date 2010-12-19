Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:32839 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755766Ab0LSUC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Dec 2010 15:02:58 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 855094061C
	for <linux-wireless@vger.kernel.org>; Sun, 19 Dec 2010 15:03:09 -0500 (EST)
Subject: Compat-wireless release for 2010-12-19 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101219200257.3848340F97@repository3.orbit-lab.org>
Date: Sun, 19 Dec 2010 15:02:57 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   880bb0b..dd8c5e7  master     -> origin/master
 * [new tag]         compat-wireless-2010-12-17 -> compat-wireless-2010-12-17
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   3547391..64bcd1b  master     -> origin/master
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

    777009 - Total upstream lines of code being pulled
      2223 - backport code changes
      1946 - backport code additions
       277 - backport code deletions
      6669 - backport from compat module
      8892 - total backport code
    1.1444 - % of code consists of backport work
      1532 - Crap changes not yet posted
      1489 - Crap additions not yet posted
        43 - Crap deletions not yet posted
    0.1972 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101217
compat-wireless release: compat-wireless-2010-12-17-pc
