Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:42455 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932644Ab1BYUGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 15:06:32 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id EF88754017F
	for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 15:09:42 -0500 (EST)
Subject: Compat-wireless release for 2011-02-25 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110225200631.55A7C46520@repository3.orbit-lab.org>
Date: Fri, 25 Feb 2011 15:06:31 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   ec19f7f..6dae501  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 4b91e9f...fa8596d akpm-end   -> origin/akpm-end  (forced update)
   4a508dd..86e2fe9  akpm-start -> origin/akpm-start
   99c2c59..b13c9c0  history    -> origin/history
 + d0ae5e3...b655770 master     -> origin/master  (forced update)
   4a508dd..86e2fe9  stable     -> origin/stable
 * [new tag]         next-20110225 -> next-20110225
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    831210 - Total upstream lines of code being pulled
      2163 - backport code changes
      1881 - backport code additions
       282 - backport code deletions
      7438 - backport from compat module
      9601 - total backport code
    1.1551 - % of code consists of backport work
