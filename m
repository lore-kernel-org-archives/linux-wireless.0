Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:50983 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751352Ab0JGTDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 15:03:19 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id E5ECA418D8
	for <linux-wireless@vger.kernel.org>; Thu,  7 Oct 2010 15:00:41 -0400 (EDT)
Subject: Compat-wireless release for 2010-10-07 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101007190318.33CC1404FC@repository3.orbit-lab.org>
Date: Thu,  7 Oct 2010 15:03:18 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   7929752..47b280b  history    -> origin/history
 + 244ae30...b1f2566 master     -> origin/master  (forced update)
   e1d9694..cb655d0  stable     -> origin/stable
 * [new tag]         next-20101007 -> next-20101007
 * [new tag]         v2.6.36-rc7 -> v2.6.36-rc7
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

    744913 - Total upstream lines of code being pulled
