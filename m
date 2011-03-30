Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:45031 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756064Ab1C3TEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 15:04:37 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 356E4540473
	for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 15:08:54 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-30 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110330190436.4E25140EAF@repository3.orbit-lab.org>
Date: Wed, 30 Mar 2011 15:04:36 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new branch]      linux-2.6.39.y -> origin/linux-2.6.39.y
   f7606f5..c6e514a  master     -> origin/master
 * [new tag]         compat-wireless-2011-03-30 -> compat-wireless-2011-03-30
 * [new tag]         compat-wireless-v2.6.39-rc1-2 -> compat-wireless-v2.6.39-rc1-2
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-v2.6.39-rc1-1 -> compat-wireless-v2.6.39-rc1-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
 * [new branch]      linux-2.6.39.y -> origin/linux-2.6.39.y
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 55370d9...0812ceb akpm-end   -> origin/akpm-end  (forced update)
   036a982..0ce790e  akpm-start -> origin/akpm-start
   48aa660..2661ba7  history    -> origin/history
 + 74bdbee...ce247ee master     -> origin/master  (forced update)
   036a982..0ce790e  stable     -> origin/stable
 * [new tag]         next-20110330 -> next-20110330
 * [new tag]         v2.6.39-rc1 -> v2.6.39-rc1
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    833105 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1544 - % of code consists of backport work
      1148 - Crap changes not yet posted
      1114 - Crap additions not yet posted
        34 - Crap deletions not yet posted
    0.1378 - % of crap code

Base tree: linux-next.git
Base tree version: next-20110330
compat-wireless release: compat-wireless-2011-03-30-pc
