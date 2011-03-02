Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:43094 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755579Ab1CBUGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 15:06:38 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id DE1D45401D1
	for <linux-wireless@vger.kernel.org>; Wed,  2 Mar 2011 15:09:56 -0500 (EST)
Subject: Compat-wireless release for 2011-03-02 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110302200635.339774652C@repository3.orbit-lab.org>
Date: Wed,  2 Mar 2011 15:06:35 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   f77cb6c..81e5185  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + a4ed5b8...2bda37d akpm-end   -> origin/akpm-end  (forced update)
   493f335..dd9c154  akpm-start -> origin/akpm-start
   2ddedf9..1954cf0  history    -> origin/history
 + c9f8564...7be2aad master     -> origin/master  (forced update)
   493f335..dd9c154  stable     -> origin/stable
 * [new tag]         next-20110302 -> next-20110302
 * [new tag]         v2.6.38-rc7 -> v2.6.38-rc7
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    831902 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1560 - % of code consists of backport work
