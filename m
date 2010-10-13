Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:56581 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751119Ab0JMTDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 15:03:22 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id B4633418D8
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:00:28 -0400 (EDT)
Subject: Compat-wireless release for 2010-10-13 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101013190321.2E6E140E24@repository3.orbit-lab.org>
Date: Wed, 13 Oct 2010 15:03:21 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   b9b0a4f..a19acd7  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   52c2826..b5f8437  history    -> origin/history
 + a5e5b8f...9df3b39 master     -> origin/master  (forced update)
   29979aa..0acc1b2  stable     -> origin/stable
 * [new tag]         next-20101013 -> next-20101013
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

    731194 - Total upstream lines of code being pulled
