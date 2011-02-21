Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:50007 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751107Ab1BUUHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 15:07:24 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 447D554029D
	for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 15:10:25 -0500 (EST)
Subject: Compat-wireless release for 2011-02-21 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110221200721.C15EE43501@repository3.orbit-lab.org>
Date: Mon, 21 Feb 2011 15:07:21 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + b6a583d...97d34f4 akpm-end   -> origin/akpm-end  (forced update)
   ee715087..6f576d5 akpm-start -> origin/akpm-start
   05136e6..07b259a  history    -> origin/history
 + 0dbc173...af3a283 master     -> origin/master  (forced update)
   ee715087..6f576d5 stable     -> origin/stable
 * [new tag]         next-20110221 -> next-20110221
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

    789311 - Total upstream lines of code being pulled
