Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:51487 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755019Ab1BWUHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 15:07:24 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 742355401D1
	for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 15:10:30 -0500 (EST)
Subject: Compat-wireless release for 2011-02-23 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110223200722.DC07F45938@repository3.orbit-lab.org>
Date: Wed, 23 Feb 2011 15:07:22 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   9827e52..44b4c85  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   2369930..ec19f7f  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 5884a13...bc8d831 akpm-end   -> origin/akpm-end  (forced update)
   6f576d5..d8204a3  akpm-start -> origin/akpm-start
   42db7b4..8e00ca7  history    -> origin/history
 + 182fa86...2c80a1c master     -> origin/master  (forced update)
   6f576d5..d8204a3  stable     -> origin/stable
 * [new tag]         next-20110223 -> next-20110223
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 * [new tag]         v2.6.38-rc6 -> v2.6.38-rc6
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

    791100 - Total upstream lines of code being pulled
      2135 - backport code changes
      1863 - backport code additions
       272 - backport code deletions
      7437 - backport from compat module
      9572 - total backport code
    1.2100 - % of code consists of backport work
