Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:42002 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751777Ab1DLTEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 15:04:10 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 04A2D540446
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 15:08:52 -0400 (EDT)
Subject: Compat-wireless release for 2011-04-12 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110412190409.1469B40EB3@repository3.orbit-lab.org>
Date: Tue, 12 Apr 2011 15:04:08 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + a5f3ae2...bc2e31b akpm-end   -> origin/akpm-end  (forced update)
   4263a2f..a6360dd  akpm-start -> origin/akpm-start
   66b7101..fdab1e2  history    -> origin/history
 + ee8870a...611af9e master     -> origin/master  (forced update)
   4263a2f..a6360dd  stable     -> origin/stable
 * [new tag]         next-20110412 -> next-20110412
 * [new tag]         v2.6.39-rc3 -> v2.6.39-rc3
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

    837874 - Total upstream lines of code being pulled
