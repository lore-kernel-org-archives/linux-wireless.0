Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:42803 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756634Ab0KMUCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 15:02:53 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 2D779418D8
	for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 14:58:36 -0500 (EST)
Subject: Compat-wireless release for 2010-11-13 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101113200252.0798140F97@repository3.orbit-lab.org>
Date: Sat, 13 Nov 2010 15:02:51 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   d9179de..12f3be5  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   fef7b52..6f82007  master     -> origin/master
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

    741659 - Total upstream lines of code being pulled
      2187 - backport code changes
      1930 - backport code additions
       257 - backport code deletions
      6360 - backport from compat module
      8547 - total backport code
    1.1524 - % of code consists of backport work
      1534 - Crap changes not yet posted
      1491 - Crap additions not yet posted
        43 - Crap deletions not yet posted
    0.2068 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101112
compat-wireless release: compat-wireless-2010-11-10-8-g12f3be5-pc
