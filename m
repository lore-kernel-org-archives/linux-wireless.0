Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:57195 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757681Ab0KRUE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 15:04:28 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 41133418D8
	for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 14:59:57 -0500 (EST)
Subject: Compat-wireless release for 2010-11-18 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101118200426.70C6F40F97@repository3.orbit-lab.org>
Date: Thu, 18 Nov 2010 15:04:26 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   12f3be5..b131f33  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   404ded5..fbf58bc  history    -> origin/history
 + 2422975...696d59d master     -> origin/master  (forced update)
   4531491..7957f0a  stable     -> origin/stable
 * [new tag]         next-20101118 -> next-20101118
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    745241 - Total upstream lines of code being pulled
      2187 - backport code changes
      1930 - backport code additions
       257 - backport code deletions
      6360 - backport from compat module
      8547 - total backport code
    1.1469 - % of code consists of backport work
      1534 - Crap changes not yet posted
      1491 - Crap additions not yet posted
        43 - Crap deletions not yet posted
    0.2058 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101118
compat-wireless release: compat-wireless-2010-11-10-9-gb131f33-pc
