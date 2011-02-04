Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:57874 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752387Ab1BDUFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 15:05:52 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 00096540155
	for <linux-wireless@vger.kernel.org>; Fri,  4 Feb 2011 15:08:18 -0500 (EST)
Subject: Compat-wireless release for 2011-02-04 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110204200551.537BC40F97@repository3.orbit-lab.org>
Date: Fri,  4 Feb 2011 15:05:51 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 6224917...da7658b akpm-end   -> origin/akpm-end  (forced update)
   afe8a88..831d52b  akpm-start -> origin/akpm-start
   5a53652..d564fa0  history    -> origin/history
 + 5ca3c5b...a2a5d7a master     -> origin/master  (forced update)
   afe8a88..831d52b  stable     -> origin/stable
 * [new tag]         next-20110204 -> next-20110204
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

    786694 - Total upstream lines of code being pulled
