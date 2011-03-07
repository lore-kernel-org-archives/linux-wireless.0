Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:34638 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755274Ab1CGUG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 15:06:56 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id D33F25401CC
	for <linux-wireless@vger.kernel.org>; Mon,  7 Mar 2011 15:10:26 -0500 (EST)
Subject: Compat-wireless release for 2011-03-07 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110307200655.1442E480AB@repository3.orbit-lab.org>
Date: Mon,  7 Mar 2011 15:06:55 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + e30f50b...abdd788 akpm-end   -> origin/akpm-end  (forced update)
   cbdbb4c..fb62c00  akpm-start -> origin/akpm-start
   d08c1d9..2ad4b4f  history    -> origin/history
 + 502d294...c45165c master     -> origin/master  (forced update)
   cbdbb4c..fb62c00  stable     -> origin/stable
 * [new tag]         next-20110307 -> next-20110307
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    831952 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1560 - % of code consists of backport work
