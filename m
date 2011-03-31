Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:60189 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753465Ab1CaTE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 15:04:28 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 4CDCA540424
	for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 15:08:47 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-31 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110331190427.57C5040EAF@repository3.orbit-lab.org>
Date: Thu, 31 Mar 2011 15:04:27 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   8490f74..5113826  linux-2.6.38.y -> origin/linux-2.6.38.y
   9e66bca..c625dee  linux-2.6.39.y -> origin/linux-2.6.39.y
   c6e514a..7b4debf  master     -> origin/master
 * [new tag]         compat-wireless-2.6.38.2-2 -> compat-wireless-2.6.38.2-2
 * [new tag]         compat-wireless-v2.6.39-rc1-3 -> compat-wireless-v2.6.39-rc1-3
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-2.6.38.2-1 -> compat-wireless-2.6.38.2-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   6e14c4a..33712ab  linux-2.6.39.y -> origin/linux-2.6.39.y
   6e14c4a..89e9cfb  master     -> origin/master
 * [new tag]         v2.6.39-rc1-1 -> v2.6.39-rc1-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 0812ceb...338bd4a akpm-end   -> origin/akpm-end  (forced update)
   0ce790e..6aba74f  akpm-start -> origin/akpm-start
   2661ba7..c435267  history    -> origin/history
 + ce247ee...e04c134 master     -> origin/master  (forced update)
   0ce790e..6aba74f  stable     -> origin/stable
 * [new tag]         next-20110331 -> next-20110331
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/net/wireless/mwifiex/Makefile: No such file or directory
make[4]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/mwifiex/Makefile'.  Stop.
make[3]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/mwifiex] Error 2
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/net/wireless/mwifiex/Makefile: No such file or directory
make[4]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/mwifiex/Makefile'.  Stop.
make[3]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/mwifiex] Error 2
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2

compat-wireless code metrics

    832857 - Total upstream lines of code being pulled
      2185 - backport code changes
      1896 - backport code additions
       289 - backport code deletions
      7518 - backport from compat module
      9703 - total backport code
    1.1650 - % of code consists of backport work
