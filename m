Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:54498 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933249Ab0HDTDj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 15:03:39 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 4B7C141959
	for <linux-wireless@vger.kernel.org>; Wed,  4 Aug 2010 15:02:30 -0400 (EDT)
Subject: Compat-wireless release for 2010-08-04 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100804190337.6AAC2408F7@repository3.orbit-lab.org>
Date: Wed,  4 Aug 2010 15:03:37 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   b3703a3..4b6128d  master     -> origin/master
   c7ecb8a..55764c1  wl         -> origin/wl
 * [new tag]         compat-wireless-2010-08-03 -> compat-wireless-2010-08-03
 * [new tag]         compat-wireless-master-2010-08-03 -> compat-wireless-master-2010-08-03
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   e67e41a..d9285f7  history    -> origin/history
 + a74255d...262e79e master     -> origin/master  (forced update)
   9fe6206..3a09b1b  stable     -> origin/stable
 * [new tag]         next-20100804 -> next-20100804
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

    494063 - Total upstream lines of code being pulled
      1475 - backport code changes
      1239 - backport code additions
       236 - backport code deletions
      5805 - backport from compat module
      7280 - total backport code
    1.4735 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2465 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100804
compat-wireless release: compat-wireless-2010-08-03
