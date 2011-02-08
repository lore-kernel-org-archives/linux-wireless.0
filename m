Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:39546 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755557Ab1BHUHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 15:07:03 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 36AF65406F7
	for <linux-wireless@vger.kernel.org>; Tue,  8 Feb 2011 15:09:37 -0500 (EST)
Subject: Compat-wireless release for 2011-02-08 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110208200701.166F840F97@repository3.orbit-lab.org>
Date: Tue,  8 Feb 2011 15:07:01 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   b90fa62..9f255e1  linux-2.6.36.y -> origin/linux-2.6.36.y
   6b436a1..41dd358  linux-2.6.37.y -> origin/linux-2.6.37.y
   90ac356..b8988ca  linux-2.6.38.y -> origin/linux-2.6.38.y
   100cb85..86702b3  master     -> origin/master
 * [new tag]         compat-wireless-v2.6.38-rc3-1 -> compat-wireless-v2.6.38-rc3-1
 * [new tag]         compat-wireless-v2.6.38-rc4-1 -> compat-wireless-v2.6.38-rc4-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-v2.6.38-rc3-2 -> compat-wireless-v2.6.38-rc3-2
 * [new tag]         compat-wireless-v2.6.38-rc3-3 -> compat-wireless-v2.6.38-rc3-3
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
 * [new branch]      linux-2.6.38.y -> origin/linux-2.6.38.y
   4bf0115..2369930  master     -> origin/master
 * [new tag]         v2.6.38-rc1-1 -> v2.6.38-rc1-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + c8750c0...5ca9d46 akpm-end   -> origin/akpm-end  (forced update)
   8dbdea8..100b33c  akpm-start -> origin/akpm-start
   960b1eb..6cdc64a  history    -> origin/history
 + 5424f20...b36eb3f master     -> origin/master  (forced update)
   8dbdea8..100b33c  stable     -> origin/stable
 * [new tag]         next-20110208 -> next-20110208
 * [new tag]         v2.6.38-rc4 -> v2.6.38-rc4
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

    786527 - Total upstream lines of code being pulled
