Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:41840 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752146Ab1BRUF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 15:05:59 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 3C562540175
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 15:08:55 -0500 (EST)
Subject: Compat-wireless release for 2011-02-18 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110218200558.07C2F434FE@repository3.orbit-lab.org>
Date: Fri, 18 Feb 2011 15:05:57 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   41dd358..fb8242b  linux-2.6.37.y -> origin/linux-2.6.37.y
   1228fde..9827e52  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 4ce7e17...b6a583d akpm-end   -> origin/akpm-end  (forced update)
   a264011..ee715087 akpm-start -> origin/akpm-start
   f77a245..05136e6  history    -> origin/history
 + 2846e61...0dbc173 master     -> origin/master  (forced update)
   a264011..ee715087 stable     -> origin/stable
 * [new tag]         next-20110218 -> next-20110218
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

    787919 - Total upstream lines of code being pulled
