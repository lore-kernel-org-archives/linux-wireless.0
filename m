Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:59741 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752678Ab0GWTDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 15:03:42 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 11955421C8
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2010 15:03:44 -0400 (EDT)
Subject: Compat-wireless release for 2010-07-23 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100723190341.473DC404F0@repository3.orbit-lab.org>
Date: Fri, 23 Jul 2010 15:03:41 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   8302dc6..b2124fd  linux-2.6.35.y -> origin/linux-2.6.35.y
 * [new tag]         compat-wireless-v2.6.35-rc6 -> compat-wireless-v2.6.35-rc6
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   afdbfed..f435fa7  history    -> origin/history
 + dd5c869...80e9579 master     -> origin/master  (forced update)
   cd5b8f8..b37fa16  stable     -> origin/stable
 * [new tag]         next-20100723 -> next-20100723
 * [new tag]         v2.6.35-rc6 -> v2.6.35-rc6

compat-wireless code metrics

    493730 - Total upstream lines of code being pulled
      1447 - backport code changes
      1211 - backport code additions
       236 - backport code deletions
      5764 - backport from compat module
      7211 - total backport code
    1.4605 - % of code consists of backport work
      1218 - Crap changes not yet posted
      1179 - Crap additions not yet posted
        39 - Crap deletions not yet posted
    0.2467 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100723
compat-wireless release: compat-wireless-2010-07-13-4-g04898a5
