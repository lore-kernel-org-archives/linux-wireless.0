Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:46268 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753882Ab0LaUEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Dec 2010 15:04:21 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 94F50542498
	for <linux-wireless@vger.kernel.org>; Fri, 31 Dec 2010 15:05:33 -0500 (EST)
Subject: Compat-wireless release for 2010-12-31 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101231200419.9088A40F97@repository3.orbit-lab.org>
Date: Fri, 31 Dec 2010 15:04:19 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   dc86c6c..9b210cb  history    -> origin/history
 + e635401...bfa221f master     -> origin/master  (forced update)
   387c31c..3643e0e  stable     -> origin/stable
 * [new tag]         next-20101231 -> next-20101231
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

    774936 - Total upstream lines of code being pulled
