Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:49185 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754306Ab0IATD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 15:03:27 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 475D8418D8
	for <linux-wireless@vger.kernel.org>; Wed,  1 Sep 2010 15:02:24 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-01 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100901190323.BA08D41134@repository3.orbit-lab.org>
Date: Wed,  1 Sep 2010 15:03:23 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   e4ae279..48c2e3c  history    -> origin/history
 + 22681a2...13a20f7 master     -> origin/master  (forced update)
 * [new tag]         next-20100901 -> next-20100901
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

    498970 - Total upstream lines of code being pulled
      1714 - backport code changes
      1475 - backport code additions
       239 - backport code deletions
      6073 - backport from compat module
      7787 - total backport code
    1.5606 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2441 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100901
compat-wireless release: compat-wireless--2010-08-30-3-g44e920c
