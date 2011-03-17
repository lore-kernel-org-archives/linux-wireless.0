Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:50178 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754052Ab1CQTF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 15:05:59 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 20CC65401D6
	for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 15:09:49 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-17 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110317190557.4CCE540EA9@repository3.orbit-lab.org>
Date: Thu, 17 Mar 2011 15:05:57 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   557ca24..6e19bea  linux-2.6.38.y -> origin/linux-2.6.38.y
   9d8e201..f7606f5  master     -> origin/master
 * [new tag]         compat-wireless-2.6.38-2 -> compat-wireless-2.6.38-2
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-2.6.38-1 -> compat-wireless-2.6.38-1
 * [new tag]         compat-wireless-2.6.38-rc7-2 -> compat-wireless-2.6.38-rc7-2
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 19f72f1...1eae6a8 akpm-end   -> origin/akpm-end  (forced update)
   76ca078..2e270d8  akpm-start -> origin/akpm-start
   22c1b5a..e413425  history    -> origin/history
 + 3cf254e...f603315 master     -> origin/master  (forced update)
   76ca078..2e270d8  stable     -> origin/stable
 * [new tag]         next-20110317 -> next-20110317
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    832392 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1553 - % of code consists of backport work
