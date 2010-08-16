Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:53293 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755897Ab0HPTDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 15:03:06 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 28BEA4195D
	for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 15:02:47 -0400 (EDT)
Subject: Compat-wireless release for 2010-08-16 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100816190303.A3FB941133@repository3.orbit-lab.org>
Date: Mon, 16 Aug 2010 15:03:03 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   16383b1..3639a89  history    -> origin/history
 + f55f020...f74eac3 master     -> origin/master  (forced update)
   ad41a1e..da5cabf  stable     -> origin/stable
 * [new tag]         next-20100816 -> next-20100816
 * [new tag]         v2.6.36-rc1 -> v2.6.36-rc1
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

    494670 - Total upstream lines of code being pulled
