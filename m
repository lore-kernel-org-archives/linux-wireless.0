Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:48811 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751830Ab0JSTDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 15:03:54 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 10A90418D8
	for <linux-wireless@vger.kernel.org>; Tue, 19 Oct 2010 15:00:44 -0400 (EDT)
Subject: Compat-wireless release for 2010-10-19 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101019190352.97DE840F97@repository3.orbit-lab.org>
Date: Tue, 19 Oct 2010 15:03:52 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   cf69aba..ab01eca  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   5e389ef..cd70b7a  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   ab7e63a..976c093  history    -> origin/history
 + c2e82bb...abe626b master     -> origin/master  (forced update)
 * [new tag]         next-20101019 -> next-20101019
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

    740505 - Total upstream lines of code being pulled
      2149 - backport code changes
      1897 - backport code additions
       252 - backport code deletions
      6390 - backport from compat module
      8539 - total backport code
    1.1531 - % of code consists of backport work
      1535 - Crap changes not yet posted
      1491 - Crap additions not yet posted
        44 - Crap deletions not yet posted
    0.2073 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101019
compat-wireless release: compat-wireless-2010-10-14-7-gab01eca-pc
