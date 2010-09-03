Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:43320 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753983Ab0ICTDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 15:03:31 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 9594A418D8
	for <linux-wireless@vger.kernel.org>; Fri,  3 Sep 2010 15:02:24 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-03 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100903190329.6C02F41134@repository3.orbit-lab.org>
Date: Fri,  3 Sep 2010 15:03:29 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   46209e3..3254605  history    -> origin/history
 + 21929b6...d24ab56 master     -> origin/master  (forced update)
 * [new tag]         next-20100903 -> next-20100903
scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile: No such file or directory
make[3]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl/Makefile'.  Stop.
make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/staging/ath6kl] Error 2
make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
make: *** [clean] Error 2

compat-wireless code metrics

    591075 - Total upstream lines of code being pulled
      1718 - backport code changes
      1477 - backport code additions
       241 - backport code deletions
      6082 - backport from compat module
      7800 - total backport code
    1.3196 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2061 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100903
compat-wireless release: compat-wireless--2010-09-02
