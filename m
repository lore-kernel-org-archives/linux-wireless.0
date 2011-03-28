Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:37579 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754336Ab1C1TEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 15:04:55 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id C2052540425
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 15:09:05 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-28 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110328190451.ED79740EAB@repository3.orbit-lab.org>
Date: Mon, 28 Mar 2011 15:04:51 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + f1829e8...2c348fb akpm-end   -> origin/akpm-end  (forced update)
   d39dd11..16c29da  akpm-start -> origin/akpm-start
   d820e1b..e5ca460  history    -> origin/history
 + 380d3c6...285d731 master     -> origin/master  (forced update)
   d39dd11..16c29da  stable     -> origin/stable
 * [new tag]         next-20110328 -> next-20110328
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    832860 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1547 - % of code consists of backport work
