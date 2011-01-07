Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:58948 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753624Ab1AGUEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 15:04:33 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id EFD21540A3C
	for <linux-wireless@vger.kernel.org>; Fri,  7 Jan 2011 15:06:00 -0500 (EST)
Subject: Compat-wireless release for 2011-01-07 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110107200432.49DE740F97@repository3.orbit-lab.org>
Date: Fri,  7 Jan 2011 15:04:32 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   07667d5..919757f  linux-2.6.37.y -> origin/linux-2.6.37.y
   c46a7ef..69ec1f8  master     -> origin/master
 * [new tag]         compat-wireless-2011-01-06 -> compat-wireless-2011-01-06
 * [new tag]         compat-wireless-v2.6.37-2 -> compat-wireless-v2.6.37-2
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   dcd6955..4bf0115  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   91493a5..d184f08  history    -> origin/history
 + 47ec851...f69eb67 master     -> origin/master  (forced update)
   3c0eee3..cb600d2  stable     -> origin/stable
 * [new tag]         next-20110107 -> next-20110107
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

    782479 - Total upstream lines of code being pulled
      2103 - backport code changes
      1843 - backport code additions
       260 - backport code deletions
      7279 - backport from compat module
      9382 - total backport code
    1.1990 - % of code consists of backport work
      1531 - Crap changes not yet posted
      1488 - Crap additions not yet posted
        43 - Crap deletions not yet posted
    0.1957 - % of crap code

Base tree: linux-next.git
Base tree version: next-20110107
compat-wireless release: compat-wireless-2011-01-06-pc
