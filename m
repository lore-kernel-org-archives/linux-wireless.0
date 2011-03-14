Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:59288 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754162Ab1CNTGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 15:06:36 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 369F9540154
	for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 15:10:20 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-14 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110314190634.71B8140EA0@repository3.orbit-lab.org>
Date: Mon, 14 Mar 2011 15:06:34 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 96bdd35...1a28402 akpm-end   -> origin/akpm-end  (forced update)
   9179746..c44ed96  akpm-start -> origin/akpm-start
   28e001e..93bb8a9  history    -> origin/history
 + 23b5ab8...c0ebee1 master     -> origin/master  (forced update)
   9179746..c44ed96  stable     -> origin/stable
 * [new tag]         next-20110314 -> next-20110314
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    832319 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1554 - % of code consists of backport work
