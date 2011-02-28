Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:56280 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753128Ab1B1UHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 15:07:32 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 44687540154
	for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 15:10:49 -0500 (EST)
Subject: Compat-wireless release for 2011-02-28 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110228200731.97B0746520@repository3.orbit-lab.org>
Date: Mon, 28 Feb 2011 15:07:31 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   74d6d79..212223d  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   6dae501..6e14c4a  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + fa8596d...3f8c23b akpm-end   -> origin/akpm-end  (forced update)
   86e2fe9..493f335  akpm-start -> origin/akpm-start
   b13c9c0..db46904  history    -> origin/history
 + b655770...5cfae13 master     -> origin/master  (forced update)
   86e2fe9..493f335  stable     -> origin/stable
 * [new tag]         next-20110228 -> next-20110228
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    831345 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1568 - % of code consists of backport work
