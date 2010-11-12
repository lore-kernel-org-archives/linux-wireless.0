Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:34723 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932166Ab0KLUD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 15:03:57 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id EEC4D418D8
	for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 14:59:42 -0500 (EST)
Subject: Compat-wireless release for 2010-11-12 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101112200356.1422740F97@repository3.orbit-lab.org>
Date: Fri, 12 Nov 2010 15:03:55 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   ae399cb..d9179de  master     -> origin/master
   2e6e721..59105ca  wl         -> origin/wl
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   ea54195..fef7b52  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   a6ca25c..522d4fb  history    -> origin/history
 + 7fe8202...e684160 master     -> origin/master  (forced update)
 * [new tag]         next-20101112 -> next-20101112
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

    741645 - Total upstream lines of code being pulled
