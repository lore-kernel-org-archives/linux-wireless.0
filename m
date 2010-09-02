Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:46302 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754486Ab0IBTDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 15:03:31 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id D8043418D8
	for <linux-wireless@vger.kernel.org>; Thu,  2 Sep 2010 15:02:27 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-02 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100902190330.007CA41134@repository3.orbit-lab.org>
Date: Thu,  2 Sep 2010 15:03:29 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   7cb5c86..315a363  linux-2.6.36.y -> origin/linux-2.6.36.y
   44e920c..3f3d080  master     -> origin/master
   f046dae..c2e94fd  wl         -> origin/wl
 * [new tag]         compat-wireless--2010-09-02 -> compat-wireless--2010-09-02
 * [new tag]         compat-wireless-master-2010-09-01 -> compat-wireless-master-2010-09-01
 * [new tag]         compat-wireless-v2.6.36-rc3-1 -> compat-wireless-v2.6.36-rc3-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   9caaec5..d066270  linux-2.6.36.y -> origin/linux-2.6.36.y
   c45d026..e13fed0  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   48c2e3c..46209e3  history    -> origin/history
 + 13a20f7...21929b6 master     -> origin/master  (forced update)
 * [new tag]         next-20100902 -> next-20100902
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile: No such file or directory
make[3]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile'.  Stop.
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile: No such file or directory
make[3]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile'.  Stop.
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile: No such file or directory
make[3]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile'.  Stop.
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2

compat-wireless code metrics

    498981 - Total upstream lines of code being pulled
      1718 - backport code changes
      1477 - backport code additions
       241 - backport code deletions
      6082 - backport from compat module
      7800 - total backport code
    1.5632 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2441 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100902
compat-wireless release: compat-wireless--2010-09-02
