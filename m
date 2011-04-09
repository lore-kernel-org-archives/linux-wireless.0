Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:58762 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753796Ab1DITCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2011 15:02:32 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 8C3BE540424
	for <linux-wireless@vger.kernel.org>; Sat,  9 Apr 2011 15:07:09 -0400 (EDT)
Subject: Compat-wireless release for 2011-04-09 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110409190231.ACB6740EB3@repository3.orbit-lab.org>
Date: Sat,  9 Apr 2011 15:02:31 -0400 (EDT)
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

    837893 - Total upstream lines of code being pulled
