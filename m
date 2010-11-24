Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:38346 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932104Ab0KXUDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 15:03:36 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 8E624418D8
	for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 14:58:49 -0500 (EST)
Subject: Compat-wireless release for 2010-11-24 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101124200335.004A040F97@repository3.orbit-lab.org>
Date: Wed, 24 Nov 2010 15:03:34 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   7670673..2a32eea  linux-2.6.36.y -> origin/linux-2.6.36.y
   4738a49..3d69e94  linux-2.6.37.y -> origin/linux-2.6.37.y
   d70fb80..9a6e31a  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-2010-11-23 -> compat-wireless-2010-11-23
 * [new tag]         compat-wireless-v2.6.37-rc3-1 -> compat-wireless-v2.6.37-rc3-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   1fce951..1d4836b  history    -> origin/history
 + c239aa9...bd59982 master     -> origin/master  (forced update)
 * [new tag]         next-20101124 -> next-20101124
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

    748874 - Total upstream lines of code being pulled
      2187 - backport code changes
      1930 - backport code additions
       257 - backport code deletions
      6439 - backport from compat module
      8626 - total backport code
    1.1519 - % of code consists of backport work
      1534 - Crap changes not yet posted
      1491 - Crap additions not yet posted
        43 - Crap deletions not yet posted
    0.2048 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101124
compat-wireless release: compat-wireless-2010-11-23-1-g9a6e31a-pc
