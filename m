Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:42790 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755138Ab0HXTDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 15:03:22 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 0FF304195D
	for <linux-wireless@vger.kernel.org>; Tue, 24 Aug 2010 15:02:43 -0400 (EDT)
Subject: Compat-wireless release for 2010-08-24 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100824190321.0A2A741133@repository3.orbit-lab.org>
Date: Tue, 24 Aug 2010 15:03:20 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   44a3497..03699ed  linux-2.6.36.y -> origin/linux-2.6.36.y
   558219f..1d39e2d  master     -> origin/master
 + a34839f...92c8a6d wl         -> origin/wl  (forced update)
 * [new tag]         compat-wireless-2010-08-23 -> compat-wireless-2010-08-23
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-v2.6.36-rc1-2 -> compat-wireless-v2.6.36-rc1-2
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   6c8895f..a65b21c  history    -> origin/history
 + 2957dad...1a28812 master     -> origin/master  (forced update)
   3dc8d7f..9ee4747  stable     -> origin/stable
 * [new tag]         next-20100824 -> next-20100824
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 * [new tag]         v2.6.36-rc2 -> v2.6.36-rc2

compat-wireless code metrics

    496308 - Total upstream lines of code being pulled
      1714 - backport code changes
      1474 - backport code additions
       240 - backport code deletions
      6070 - backport from compat module
      7784 - total backport code
    1.5684 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2454 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100824
compat-wireless release: compat-wireless-2010-08-23
