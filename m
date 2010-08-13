Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:38593 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753935Ab0HMTDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Aug 2010 15:03:08 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id BFB574195D
	for <linux-wireless@vger.kernel.org>; Fri, 13 Aug 2010 15:02:55 -0400 (EDT)
Subject: Compat-wireless release for 2010-08-13 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100813190304.3D8D641133@repository3.orbit-lab.org>
Date: Fri, 13 Aug 2010 15:03:04 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   286bff9..16383b1  history    -> origin/history
 + ab5f7cf...f55f020 master     -> origin/master  (forced update)
   5af568c..ad41a1e  stable     -> origin/stable
 * [new tag]         next-20100813 -> next-20100813
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

    494644 - Total upstream lines of code being pulled
