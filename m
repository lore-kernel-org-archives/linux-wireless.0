Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:49309 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752465Ab1CKUHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:07:23 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id C0294540186
	for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 15:11:01 -0500 (EST)
Subject: Compat-wireless release for 2011-03-11 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110311200721.E7BA840E98@repository3.orbit-lab.org>
Date: Fri, 11 Mar 2011 15:07:21 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + a6aeafb...96bdd35 akpm-end   -> origin/akpm-end  (forced update)
   3979491..9179746  akpm-start -> origin/akpm-start
   3a91f09..28e001e  history    -> origin/history
 + d1f497c...23b5ab8 master     -> origin/master  (forced update)
   3979491..9179746  stable     -> origin/stable
 * [new tag]         next-20110311 -> next-20110311
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    831956 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1560 - % of code consists of backport work
