Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:45080 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759928Ab1CDUGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 15:06:33 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 9BE0E540175
	for <linux-wireless@vger.kernel.org>; Fri,  4 Mar 2011 15:09:57 -0500 (EST)
Subject: Compat-wireless release for 2011-03-04 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110304200631.D22A345796@repository3.orbit-lab.org>
Date: Fri,  4 Mar 2011 15:06:31 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   b8988ca..557ca24  linux-2.6.38.y -> origin/linux-2.6.38.y
 * [new tag]         compat-wireless-v2.6.38-rc7-1 -> compat-wireless-v2.6.38-rc7-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   f3ef28f..0dee4ea  linux-2.6.38.y -> origin/linux-2.6.38.y
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 880ce2e...e30f50b akpm-end   -> origin/akpm-end  (forced update)
   dd9c154..cbdbb4c  akpm-start -> origin/akpm-start
   b7498f3..d08c1d9  history    -> origin/history
 + 2afa434...502d294 master     -> origin/master  (forced update)
   dd9c154..cbdbb4c  stable     -> origin/stable
 * [new tag]         next-20110304 -> next-20110304
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    831498 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1566 - % of code consists of backport work
