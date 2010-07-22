Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:60432 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751270Ab0GVTDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 15:03:46 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 41DF1421C8
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 15:03:45 -0400 (EDT)
Subject: Compat-wireless release for 2010-07-22 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100722190343.1E4BD404F0@repository3.orbit-lab.org>
Date: Thu, 22 Jul 2010 15:03:43 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   1a05138..04898a5  master     -> origin/master
   0442f68..c7ecb8a  wl         -> origin/wl
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   5f11688..afdbfed  history    -> origin/history
 + fecd01b...dd5c869 master     -> origin/master  (forced update)
   e095937..cd5b8f8  stable     -> origin/stable
 * [new tag]         next-20100722 -> next-20100722
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

    493727 - Total upstream lines of code being pulled
      1447 - backport code changes
      1211 - backport code additions
       236 - backport code deletions
      5764 - backport from compat module
      7211 - total backport code
    1.4605 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2467 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100722
compat-wireless release: compat-wireless-2010-07-13-4-g04898a5
