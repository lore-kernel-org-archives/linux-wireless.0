Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:50209 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755432Ab0JNTDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 15:03:17 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id CDCD0418D8
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 15:00:20 -0400 (EDT)
Subject: Compat-wireless release for 2010-10-14 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101014190315.F1E1440E24@repository3.orbit-lab.org>
Date: Thu, 14 Oct 2010 15:03:15 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   b5f8437..5f73e94  history    -> origin/history
 + 9df3b39...39f2bd6 master     -> origin/master  (forced update)
 * [new tag]         next-20101014 -> next-20101014
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

    731221 - Total upstream lines of code being pulled
