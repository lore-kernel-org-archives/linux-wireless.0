Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:55701 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932095Ab0LIUEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:22 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id DE7E9418D8
	for <linux-wireless@vger.kernel.org>; Thu,  9 Dec 2010 14:58:55 -0500 (EST)
Subject: Compat-wireless release for 2010-12-09 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101209200421.7838A40F97@repository3.orbit-lab.org>
Date: Thu,  9 Dec 2010 15:04:21 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   d345c48..b2c2e68  linux-2.6.37.y -> origin/linux-2.6.37.y
   6545cbe..4a59d8a  master     -> origin/master
 * [new tag]         compat-wireless-2010-12-08 -> compat-wireless-2010-12-08
 * [new tag]         compat-wireless-v2.6.37-rc5-2 -> compat-wireless-v2.6.37-rc5-2
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-v2.6.37-rc5-1 -> compat-wireless-v2.6.37-rc5-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   0894957..464643e  history    -> origin/history
 + 9cf13db...df9e9ad master     -> origin/master  (forced update)
   81e8d21..6313e3c  stable     -> origin/stable
 * [new tag]         next-20101209 -> next-20101209
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

    752670 - Total upstream lines of code being pulled
