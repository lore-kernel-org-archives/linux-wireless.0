Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:54211 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932256Ab0HCTDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 15:03:15 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 138A441959
	for <linux-wireless@vger.kernel.org>; Tue,  3 Aug 2010 15:02:14 -0400 (EDT)
Subject: Compat-wireless release for 2010-08-03 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100803190313.AB767408F7@repository3.orbit-lab.org>
Date: Tue,  3 Aug 2010 15:03:13 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   523343a..e67e41a  history    -> origin/history
 + 539c54f...a74255d master     -> origin/master  (forced update)
 * [new tag]         next-20100803 -> next-20100803
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

    494063 - Total upstream lines of code being pulled
