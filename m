Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:44674 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756417Ab1BXUH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 15:07:26 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 4148254017C
	for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2011 15:10:34 -0500 (EST)
Subject: Compat-wireless release for 2011-02-24 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110224200724.9EE0346520@repository3.orbit-lab.org>
Date: Thu, 24 Feb 2011 15:07:24 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   44b4c85..74d6d79  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + bc8d831...4b91e9f akpm-end   -> origin/akpm-end  (forced update)
   d8204a3..4a508dd  akpm-start -> origin/akpm-start
   8e00ca7..99c2c59  history    -> origin/history
 + 2c80a1c...d0ae5e3 master     -> origin/master  (forced update)
   d8204a3..4a508dd  stable     -> origin/stable
 * [new tag]         next-20110224 -> next-20110224
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
      7437 - backport from compat module
      9600 - total backport code
    1.1549 - % of code consists of backport work
