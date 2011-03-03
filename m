Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:38913 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758748Ab1CCUGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 15:06:15 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 89156540186
	for <linux-wireless@vger.kernel.org>; Thu,  3 Mar 2011 15:09:37 -0500 (EST)
Subject: Compat-wireless release for 2011-03-03 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110303200613.BEA6F4652C@repository3.orbit-lab.org>
Date: Thu,  3 Mar 2011 15:06:13 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   81e5185..9d8e201  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 2bda37d...880ce2e akpm-end   -> origin/akpm-end  (forced update)
   1954cf0..b7498f3  history    -> origin/history
 + 7be2aad...2afa434 master     -> origin/master  (forced update)
 * [new tag]         next-20110303 -> next-20110303
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    831898 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1560 - % of code consists of backport work
