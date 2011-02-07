Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:54204 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753425Ab1BGUGr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 15:06:47 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id CBB3754009C
	for <linux-wireless@vger.kernel.org>; Mon,  7 Feb 2011 15:09:19 -0500 (EST)
Subject: Compat-wireless release for 2011-02-07 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110207200645.CB44240F97@repository3.orbit-lab.org>
Date: Mon,  7 Feb 2011 15:06:45 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + da7658b...c8750c0 akpm-end   -> origin/akpm-end  (forced update)
   831d52b..8dbdea8  akpm-start -> origin/akpm-start
   d564fa0..960b1eb  history    -> origin/history
 + a2a5d7a...5424f20 master     -> origin/master  (forced update)
   831d52b..8dbdea8  stable     -> origin/stable
 * [new tag]         next-20110207 -> next-20110207
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

    786482 - Total upstream lines of code being pulled
