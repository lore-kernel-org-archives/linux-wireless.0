Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:37463 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932077Ab0JOTDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 15:03:40 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id A1328418D8
	for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 15:00:41 -0400 (EDT)
Subject: Compat-wireless release for 2010-10-15 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101015190339.77C3540E24@repository3.orbit-lab.org>
Date: Fri, 15 Oct 2010 15:03:39 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   f2e8f16..1c390e6  linux-2.6.36.y -> origin/linux-2.6.36.y
   a19acd7..f0578ae  master     -> origin/master
 * [new tag]         compat-wireless-v2.6.36-rc8-1 -> compat-wireless-v2.6.36-rc8-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-2010-10-14 -> compat-wireless-2010-10-14
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   5f73e94..4bd98fd  history    -> origin/history
 + 39f2bd6...a26d875 master     -> origin/master  (forced update)
   0acc1b2..3aa0ce8  stable     -> origin/stable
 * [new tag]         next-20101015 -> next-20101015
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

    741071 - Total upstream lines of code being pulled
      2157 - backport code changes
      1905 - backport code additions
       252 - backport code deletions
      6388 - backport from compat module
      8545 - total backport code
    1.1531 - % of code consists of backport work
      1535 - Crap changes not yet posted
      1491 - Crap additions not yet posted
        44 - Crap deletions not yet posted
    0.2071 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101015
compat-wireless release: compat-wireless-2010-10-14-1-gf0578ae-pc
