Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:44535 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751266Ab1BBUGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 15:06:31 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id BC5235400F2
	for <linux-wireless@vger.kernel.org>; Wed,  2 Feb 2011 15:08:53 -0500 (EST)
Subject: Compat-wireless release for 2011-02-02 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110202200630.4C69B40F97@repository3.orbit-lab.org>
Date: Wed,  2 Feb 2011 15:06:30 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + d2627ce...6eaa0ba akpm-end   -> origin/akpm-end  (forced update)
   7921127..afe8a88  akpm-start -> origin/akpm-start
   7911a84..929e642  history    -> origin/history
 + 906227e...79333d1 master     -> origin/master  (forced update)
   7921127..afe8a88  stable     -> origin/stable
 * [new tag]         next-20110202 -> next-20110202
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 * [new tag]         v2.6.38-rc3 -> v2.6.38-rc3
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
