Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:47828 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755816Ab0I0TDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 15:03:45 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 48E54418D8
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 15:01:34 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-27 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100927190343.A0165404FC@repository3.orbit-lab.org>
Date: Mon, 27 Sep 2010 15:03:43 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   f3710cc..96d9e6e  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-2010-09-27 -> compat-wireless-2010-09-27
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   0563b86..edd6839  history    -> origin/history
 + 15dadf4...35b3f2c master     -> origin/master  (forced update)
   a850ea3..32163f4  stable     -> origin/stable
 * [new tag]         next-20100927 -> next-20100927
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

    747606 - Total upstream lines of code being pulled
      2153 - backport code changes
      1902 - backport code additions
       251 - backport code deletions
      6242 - backport from compat module
      8395 - total backport code
    1.1229 - % of code consists of backport work
      1219 - Crap changes not yet posted
      1181 - Crap additions not yet posted
        38 - Crap deletions not yet posted
    0.1631 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100927
compat-wireless release: compat-wireless-2010-09-27-1-g96d9e6e
