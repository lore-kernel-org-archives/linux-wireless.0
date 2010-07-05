Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:47327 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751102Ab0GETDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 15:03:05 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id AC52B42042
	for <linux-wireless@vger.kernel.org>; Mon,  5 Jul 2010 15:06:24 -0400 (EDT)
Subject: Compat-wireless release for 2010-07-05 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100705190300.2A16242E2C@repository3.orbit-lab.org>
Date: Mon,  5 Jul 2010 15:03:00 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   c48fe0c..39a2e97  history    -> origin/history
 + 4985a03...2880928 master     -> origin/master  (forced update)
   9fbd7f9..123f94f  stable     -> origin/stable
 * [new tag]         next-20100705 -> next-20100705
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

    494471 - Total upstream lines of code being pulled
