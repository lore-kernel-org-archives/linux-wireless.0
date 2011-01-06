Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:56154 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751257Ab1AFUEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 15:04:14 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id CFD9A5407CD
	for <linux-wireless@vger.kernel.org>; Thu,  6 Jan 2011 15:05:39 -0500 (EST)
Subject: Compat-wireless release for 2011-01-06 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110106200413.4007940F97@repository3.orbit-lab.org>
Date: Thu,  6 Jan 2011 15:04:13 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   fc63933..07667d5  linux-2.6.37.y -> origin/linux-2.6.37.y
   53f8e22..c46a7ef  master     -> origin/master
 * [new tag]         compat-wireless-2011-01-05 -> compat-wireless-2011-01-05
 * [new tag]         compat-wireless-v2.6.37-1 -> compat-wireless-v2.6.37-1
 * [new tag]         compat-wireless-v2.6.37-rc6-2 -> compat-wireless-v2.6.37-rc6-2
 * [new tag]         compat-wireless-v2.6.37-rc6-3 -> compat-wireless-v2.6.37-rc6-3
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   d70640f..dcd6955  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   b616059..91493a5  history    -> origin/history
 + dcd2e87...47ec851 master     -> origin/master  (forced update)
   989d873..3c0eee3  stable     -> origin/stable
 * [new tag]         next-20110106 -> next-20110106
 * [new tag]         v2.6.37    -> v2.6.37
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
/usr/bin/sha1sum: *.tar.bz2: No such file or directory

compat-wireless code metrics

    781248 - Total upstream lines of code being pulled
