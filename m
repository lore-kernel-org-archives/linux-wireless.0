Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:51036 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754390Ab0IPTEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 15:04:14 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 8F8A7418D8
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 15:02:32 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-16 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100916190412.42E4C41134@repository3.orbit-lab.org>
Date: Thu, 16 Sep 2010 15:04:12 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   315a363..84ac593  linux-2.6.36.y -> origin/linux-2.6.36.y
   f63dbfd..9c47425  master     -> origin/master
 + c2e94fd...6678d67 wl         -> origin/wl  (forced update)
 * [new tag]         compat-wireless-master-2010-09-14 -> compat-wireless-master-2010-09-14
 * [new tag]         describe   -> describe
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   48926c5..ea84094  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   7b71870..abc3a88  history    -> origin/history
 + 8616cf4...09e4703 master     -> origin/master  (forced update)
 * [new tag]         next-20100916 -> next-20100916
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/net/wireless/ath/carl9170/Makefile: No such file or directory
make[5]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/ath/carl9170/Makefile'.  Stop.
make[4]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/ath/carl9170] Error 2
make[3]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/ath] Error 2
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2

compat-wireless code metrics

    707224 - Total upstream lines of code being pulled
