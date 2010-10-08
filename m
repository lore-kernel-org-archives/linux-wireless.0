Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:54726 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932273Ab0JHTEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 15:04:23 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 2D535418D8
	for <linux-wireless@vger.kernel.org>; Fri,  8 Oct 2010 15:01:43 -0400 (EDT)
Subject: Compat-wireless release for 2010-10-08 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101008190422.22234404FC@repository3.orbit-lab.org>
Date: Fri,  8 Oct 2010 15:04:21 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   a582554..b9b0a4f  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   d003671..10ae528  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   47b280b..e8ed30b  history    -> origin/history
 + b1f2566...e7c029d master     -> origin/master  (forced update)
   cb655d0..6b0cd00  stable     -> origin/stable
 * [new tag]         next-20101008 -> next-20101008
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

    744319 - Total upstream lines of code being pulled
      2157 - backport code changes
      1905 - backport code additions
       252 - backport code deletions
      6387 - backport from compat module
      8544 - total backport code
    1.1479 - % of code consists of backport work
      1219 - Crap changes not yet posted
      1181 - Crap additions not yet posted
        38 - Crap deletions not yet posted
    0.1638 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101008
compat-wireless release: compat-wireless-2010-10-01-10-gb9b0a4f-pc
