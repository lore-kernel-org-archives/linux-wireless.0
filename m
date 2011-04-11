Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:44325 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755518Ab1DKTEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 15:04:49 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 56A1E5401D1
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 15:09:30 -0400 (EDT)
Subject: Compat-wireless release for 2011-04-11 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110411190448.6903D40EB3@repository3.orbit-lab.org>
Date: Mon, 11 Apr 2011 15:04:48 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + f8a3689...a5f3ae2 akpm-end   -> origin/akpm-end  (forced update)
   0c3efe5..4263a2f  akpm-start -> origin/akpm-start
   ef6aaf4..66b7101  history    -> origin/history
 + 129f038...ee8870a master     -> origin/master  (forced update)
   0c3efe5..4263a2f  stable     -> origin/stable
 * [new tag]         next-20110411 -> next-20110411
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

    837881 - Total upstream lines of code being pulled
