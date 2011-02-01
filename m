Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:39992 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751266Ab1BAUGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 15:06:36 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 2DAEB54080C
	for <linux-wireless@vger.kernel.org>; Tue,  1 Feb 2011 15:08:56 -0500 (EST)
Subject: Compat-wireless release for 2011-02-01 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110201200634.D002740F97@repository3.orbit-lab.org>
Date: Tue,  1 Feb 2011 15:06:34 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new branch]      linux-2.6.38.y -> origin/linux-2.6.38.y
   8db1608..100cb85  master     -> origin/master
 * [new tag]         compat-wireless-2011-01-31 -> compat-wireless-2011-01-31
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + c1649b7...d2627ce akpm-end   -> origin/akpm-end  (forced update)
   1f0324c..7921127  akpm-start -> origin/akpm-start
   c68e951..7911a84  history    -> origin/history
 + 89d343a...906227e master     -> origin/master  (forced update)
   1f0324c..7921127  stable     -> origin/stable
 * [new tag]         next-20110201 -> next-20110201
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

    786110 - Total upstream lines of code being pulled
