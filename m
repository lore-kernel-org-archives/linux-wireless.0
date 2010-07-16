Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:46080 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754752Ab0GPTDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 15:03:34 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 88DE5403DA
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jul 2010 15:03:41 -0400 (EDT)
Subject: Compat-wireless release for 2010-07-16 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100716190331.89291404F0@repository3.orbit-lab.org>
Date: Fri, 16 Jul 2010 15:03:31 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   4ebcc6c..0442f68  wl         -> origin/wl
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   bc3e7ea..91f06bd  history    -> origin/history
 + 732f7b0...c221ef7 master     -> origin/master  (forced update)
   1c5474a..2f7989e  stable     -> origin/stable
 * [new tag]         next-20100716 -> next-20100716

compat-wireless code metrics

    494061 - Total upstream lines of code being pulled
      1447 - backport code changes
      1211 - backport code additions
       236 - backport code deletions
      5766 - backport from compat module
      7213 - total backport code
    1.4599 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2465 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100716
compat-wireless release: compat-wireless-2010-07-13-3-g1a05138
