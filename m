Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:40363 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750767Ab1DATDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 15:03:51 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 942F85400DD
	for <linux-wireless@vger.kernel.org>; Fri,  1 Apr 2011 15:08:11 -0400 (EDT)
Subject: Compat-wireless release for 2011-04-01 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110401190349.A56ED40EAF@repository3.orbit-lab.org>
Date: Fri,  1 Apr 2011 15:03:49 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   c625dee..1d65853  linux-2.6.39.y -> origin/linux-2.6.39.y
   7b4debf..6a250de  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   33712ab..3f34341  linux-2.6.39.y -> origin/linux-2.6.39.y
   89e9cfb..c932d97  master     -> origin/master
 * [new tag]         v2.6.39-rc1-2 -> v2.6.39-rc1-2
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 338bd4a...a2471e3 akpm-end   -> origin/akpm-end  (forced update)
   c435267..3f0f2e0  history    -> origin/history
 + e04c134...260080e master     -> origin/master  (forced update)
 * [new tag]         next-20110401 -> next-20110401
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/net/wireless/mwifiex/Makefile: No such file or directory
make[4]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/mwifiex/Makefile'.  Stop.
make[3]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/mwifiex] Error 2
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2
/usr/bin/sha1sum: *.tar.bz2: No such file or directory

compat-wireless code metrics

    858087 - Total upstream lines of code being pulled
