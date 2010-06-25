Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:59441 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751461Ab0FYTD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 15:03:26 -0400
Subject: Compat-wireless release for 2010-06-25 is baked
To: <linux-wireless@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
Message-Id: <20100625190323.2299742E2C@repository3.orbit-lab.org>
Date: Fri, 25 Jun 2010 15:03:23 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   87dca92..8a97897  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   b6af507..126c387  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   2e58c02..138f35f  history    -> origin/history
 + df17781...c3116ae master     -> origin/master  (forced update)
 * [new tag]         next-20100625 -> next-20100625
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

    494345 - Total upstream lines of code being pulled
      1407 - backport code changes
      1174 - backport code additions
       233 - backport code deletions
      5765 - backport from compat module
      7172 - total backport code
    1.4508 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2464 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100625
compat-wireless release: compat-wireless-2010-06-17-6-g8a97897
