Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:52509 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751979Ab0GATC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 15:02:59 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id A5D4042042
	for <linux-wireless@vger.kernel.org>; Thu,  1 Jul 2010 15:06:01 -0400 (EDT)
Subject: Compat-wireless release for 2010-07-01 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100701190257.6256B42E2C@repository3.orbit-lab.org>
Date: Thu,  1 Jul 2010 15:02:57 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   85e0e99..a348d8b  history    -> origin/history
 + 7a6353a...fb4cbff master     -> origin/master  (forced update)
 * [new tag]         next-20100701 -> next-20100701
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

    494454 - Total upstream lines of code being pulled
