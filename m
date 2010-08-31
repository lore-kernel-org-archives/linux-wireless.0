Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:43676 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751911Ab0HaTDU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 15:03:20 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id C4B6B4195D
	for <linux-wireless@vger.kernel.org>; Tue, 31 Aug 2010 15:02:22 -0400 (EDT)
Subject: Compat-wireless release for 2010-08-31 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100831190319.8945041133@repository3.orbit-lab.org>
Date: Tue, 31 Aug 2010 15:03:19 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   4207d04..44e920c  master     -> origin/master
   502cb34..f046dae  wl         -> origin/wl
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless--2010-08-30 -> compat-wireless--2010-08-30
 * [new tag]         compat-wireless-master-2010-08-30 -> compat-wireless-master-2010-08-30
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   6561208..c45d026  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   bd4dea0..e4ae279  history    -> origin/history
 + b436937...22681a2 master     -> origin/master  (forced update)
 * [new tag]         next-20100831 -> next-20100831
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
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile: No such file or directory
make[3]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile'.  Stop.
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile: No such file or directory
make[3]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile'.  Stop.
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2

compat-wireless code metrics

    497993 - Total upstream lines of code being pulled
      1714 - backport code changes
      1475 - backport code additions
       239 - backport code deletions
      6073 - backport from compat module
      7787 - total backport code
    1.5637 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2446 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100831
compat-wireless release: compat-wireless--2010-08-30-3-g44e920c
