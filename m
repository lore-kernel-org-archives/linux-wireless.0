Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:45938 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755446Ab1CAUGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:06:44 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 90242540186
	for <linux-wireless@vger.kernel.org>; Tue,  1 Mar 2011 15:10:02 -0500 (EST)
Subject: Compat-wireless release for 2011-03-01 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110301200642.E10B34652C@repository3.orbit-lab.org>
Date: Tue,  1 Mar 2011 15:06:42 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   212223d..f77cb6c  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 3f8c23b...a4ed5b8 akpm-end   -> origin/akpm-end  (forced update)
   db46904..2ddedf9  history    -> origin/history
 + 5cfae13...c9f8564 master     -> origin/master  (forced update)
 * [new tag]         next-20110301 -> next-20110301
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    831390 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1567 - % of code consists of backport work
