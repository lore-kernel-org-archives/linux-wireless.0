Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:46210 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752667Ab1BEUC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Feb 2011 15:02:26 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 913CA5400B5
	for <linux-wireless@vger.kernel.org>; Sat,  5 Feb 2011 15:04:54 -0500 (EST)
Subject: Compat-wireless release for 2011-02-05 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110205200224.D49B640F97@repository3.orbit-lab.org>
Date: Sat,  5 Feb 2011 15:02:24 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
/usr/bin/sha1sum: *.tar.bz2: No such file or directory

compat-wireless code metrics

    786694 - Total upstream lines of code being pulled
