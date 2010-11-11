Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:51440 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755626Ab0KKUDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 15:03:51 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 22E41418D8
	for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 14:59:39 -0500 (EST)
Subject: Compat-wireless release for 2010-11-11 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101111200349.8E53440F97@repository3.orbit-lab.org>
Date: Thu, 11 Nov 2010 15:03:49 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   3eb8cae..ae399cb  master     -> origin/master
 + b1d3753...2e6e721 wl         -> origin/wl  (forced update)
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-2010-11-10 -> compat-wireless-2010-11-10
 * [new tag]         compat-wireless-master-2010-11-10 -> compat-wireless-master-2010-11-10
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   af9fe6f..ea54195  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   843502c..a6ca25c  history    -> origin/history
 + 33e8f68...7fe8202 master     -> origin/master  (forced update)
 * [new tag]         next-20101111 -> next-20101111
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

    741677 - Total upstream lines of code being pulled
