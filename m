Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:53372 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754476Ab0IVTDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 15:03:01 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id C1901418D8
	for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 15:01:03 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-22 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100922190259.A1940404FC@repository3.orbit-lab.org>
Date: Wed, 22 Sep 2010 15:02:59 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   6084a5d..ebd550e  master     -> origin/master
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

    719868 - Total upstream lines of code being pulled
      2147 - backport code changes
      1899 - backport code additions
       248 - backport code deletions
      6240 - backport from compat module
      8387 - total backport code
    1.1651 - % of code consists of backport work
      1219 - Crap changes not yet posted
      1181 - Crap additions not yet posted
        38 - Crap deletions not yet posted
    0.1693 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100921
compat-wireless release: compat-wireless--2010-09-02-22-gebd550e
