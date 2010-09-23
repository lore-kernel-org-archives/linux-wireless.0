Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:60362 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754972Ab0IWTD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 15:03:57 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id A4CE7418D8
	for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 15:01:57 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-23 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100923190356.35AC4404FC@repository3.orbit-lab.org>
Date: Thu, 23 Sep 2010 15:03:56 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   ebd550e..f3710cc  master     -> origin/master
 + 6678d67...b1d3753 wl         -> origin/wl  (forced update)
 * [new tag]         compat-wireless-2010-09-23 -> compat-wireless-2010-09-23
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   0912b47..91c40c1  history    -> origin/history
 + fadb46c...797bd52 master     -> origin/master  (forced update)
   b30a3f6..c79bd89  stable     -> origin/stable
 * [new tag]         next-20100923 -> next-20100923

compat-wireless code metrics

    747510 - Total upstream lines of code being pulled
      2147 - backport code changes
      1899 - backport code additions
       248 - backport code deletions
      6240 - backport from compat module
      8387 - total backport code
    1.1220 - % of code consists of backport work
      1219 - Crap changes not yet posted
      1181 - Crap additions not yet posted
        38 - Crap deletions not yet posted
    0.1631 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100923
compat-wireless release: compat-wireless-2010-09-23
