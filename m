Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:40957 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755651Ab0LDUCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 15:02:50 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id E396A418D8
	for <linux-wireless@vger.kernel.org>; Sat,  4 Dec 2010 14:57:36 -0500 (EST)
Subject: Compat-wireless release for 2010-12-04 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101204200249.298B040F97@repository3.orbit-lab.org>
Date: Sat,  4 Dec 2010 15:02:49 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   4386744..6545cbe  master     -> origin/master
 * [new tag]         compat-wireless-20010-12-03 -> compat-wireless-20010-12-03
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

    750561 - Total upstream lines of code being pulled
      2201 - backport code changes
      1939 - backport code additions
       262 - backport code deletions
      6637 - backport from compat module
      8838 - total backport code
    1.1775 - % of code consists of backport work
      1532 - Crap changes not yet posted
      1489 - Crap additions not yet posted
        43 - Crap deletions not yet posted
    0.2041 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101203
compat-wireless release: compat-wireless-20010-12-03-pc
