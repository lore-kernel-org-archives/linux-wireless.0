Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:40650 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754866Ab0IMTDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 15:03:41 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 80C20418D8
	for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 15:02:08 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-13 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100913190340.2725341134@repository3.orbit-lab.org>
Date: Mon, 13 Sep 2010 15:03:40 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   3f3d080..ed88df3  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   e13fed0..48926c5  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   79959c2..9bf4a20  history    -> origin/history
 + c204dd8...eb538fd master     -> origin/master  (forced update)
   d56557a..49553c2  stable     -> origin/stable
 * [new tag]         next-20100913 -> next-20100913
 * [new tag]         v2.6.36-rc4 -> v2.6.36-rc4
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/staging/brcm80211/Makefile: No such file or directory
make[3]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/staging/brcm80211/Makefile'.  Stop.
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/staging/brcm80211] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2

compat-wireless code metrics

    707137 - Total upstream lines of code being pulled
