Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:50505 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751943Ab1BJUGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 15:06:11 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 64B265405FA
	for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 15:08:50 -0500 (EST)
Subject: Compat-wireless release for 2011-02-10 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110210200610.16BD142F5C@repository3.orbit-lab.org>
Date: Thu, 10 Feb 2011 15:06:09 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   86702b3..1228fde  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 1e51b82...fe668b0 akpm-end   -> origin/akpm-end  (forced update)
   100b33c..d3d373e  akpm-start -> origin/akpm-start
   53b8b03..90bf504  history    -> origin/history
 + 2a479d2...d409db5 master     -> origin/master  (forced update)
   100b33c..d3d373e  stable     -> origin/stable
 * [new tag]         next-20110210 -> next-20110210
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

    786829 - Total upstream lines of code being pulled
      2093 - backport code changes
      1831 - backport code additions
       262 - backport code deletions
      7292 - backport from compat module
      9385 - total backport code
    1.1928 - % of code consists of backport work
