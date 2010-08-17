Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:38416 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751259Ab0HQTDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 15:03:55 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 80FC34195D
	for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 15:03:32 -0400 (EDT)
Subject: Compat-wireless release for 2010-08-17 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100817190351.ACDEB41133@repository3.orbit-lab.org>
Date: Tue, 17 Aug 2010 15:03:51 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new branch]      linux-2.6.36.y -> origin/linux-2.6.36.y
   7746bc0..4c0ceee  master     -> origin/master
 * [new tag]         compat-wireless-2010-08-16 -> compat-wireless-2010-08-16
 * [new tag]         compat-wireless-master-2010-08-05 -> compat-wireless-master-2010-08-05
 * [new tag]         compat-wireless-v2.6.36-rc1 -> compat-wireless-v2.6.36-rc1
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
 * [new branch]      linux-2.6.36.y -> origin/linux-2.6.36.y
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   3639a89..ffefdc0  history    -> origin/history
 + f74eac3...ef937c2 master     -> origin/master  (forced update)
 * [new tag]         next-20100817 -> next-20100817
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

    495649 - Total upstream lines of code being pulled
      1699 - backport code changes
      1460 - backport code additions
       239 - backport code deletions
      5979 - backport from compat module
      7678 - total backport code
    1.5491 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2457 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100817
compat-wireless release: compat-wireless-2010-08-16
