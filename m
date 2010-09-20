Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:59009 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757088Ab0ITTDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 15:03:30 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id E9F36418D8
	for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 15:01:37 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-20 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100920190328.712B1404FC@repository3.orbit-lab.org>
Date: Mon, 20 Sep 2010 15:03:28 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   b5810c4..166bcca  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   ea84094..1594b0d  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   103f01c..cc4b3b5  history    -> origin/history
 + cb131d8...9637b06 master     -> origin/master  (forced update)
   03a7ab0..2422084  stable     -> origin/stable
 * [new tag]         next-20100920 -> next-20100920
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

    719502 - Total upstream lines of code being pulled
