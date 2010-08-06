Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:50964 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965293Ab0HFTDn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 15:03:43 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 3B6C04195D
	for <linux-wireless@vger.kernel.org>; Fri,  6 Aug 2010 15:02:18 -0400 (EDT)
Subject: Compat-wireless release for 2010-08-06 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100806190340.9A51441133@repository3.orbit-lab.org>
Date: Fri,  6 Aug 2010 15:03:38 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   1bf4bba..bd3cf78  linux-2.6.35.y -> origin/linux-2.6.35.y
   55764c1..8eb662b  wl         -> origin/wl
 * [new tag]         compat-wireless-v2.6.35-1 -> compat-wireless-v2.6.35-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   464e8d5..9855656  linux-2.6.35.y -> origin/linux-2.6.35.y
   226b1c2..d6f0174  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   8a39b1f..b7cb6f4  history    -> origin/history
 + b07c08d...598a80f master     -> origin/master  (forced update)
   3cfc2c4..fc1caf6  stable     -> origin/stable
 * [new tag]         next-20100806 -> next-20100806

compat-wireless code metrics

    494668 - Total upstream lines of code being pulled
      1532 - backport code changes
      1296 - backport code additions
       236 - backport code deletions
      5805 - backport from compat module
      7337 - total backport code
    1.4832 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2462 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100806
compat-wireless release: compat-wireless-2010-08-03-1-g3672499
