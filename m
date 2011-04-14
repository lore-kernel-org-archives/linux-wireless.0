Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:58931 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932485Ab1DNTEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 15:04:24 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id AC9A65400DD
	for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 15:09:10 -0400 (EDT)
Subject: Compat-wireless release for 2011-04-14 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110414190422.B1AA640EB5@repository3.orbit-lab.org>
Date: Thu, 14 Apr 2011 15:04:22 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 75a9436...73fa655 akpm-end   -> origin/akpm-end  (forced update)
   aaa119a..85f2e68  akpm-start -> origin/akpm-start
   f093e8a..f7cc2f6  history    -> origin/history
 + 13ceff9...9e06a6e master     -> origin/master  (forced update)
   aaa119a..85f2e68  stable     -> origin/stable
 * [new tag]         69a07f0b117a40fcc1a479358d8e1f41793617f2 -> 69a07f0b117a40fcc1a479358d8e1f41793617f2
 * [new tag]         next-20110414 -> next-20110414
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

    839618 - Total upstream lines of code being pulled
