Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:48921 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752933Ab1CUTFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 15:05:23 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 3470F540154
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 15:09:22 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-21 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110321190522.4CD8340EAA@repository3.orbit-lab.org>
Date: Mon, 21 Mar 2011 15:05:21 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + ede9e56...d7f2ee7 akpm-end   -> origin/akpm-end  (forced update)
   7b7adc4..a952baa  akpm-start -> origin/akpm-start
   56c7693..29bb428  history    -> origin/history
 + 1a94657...d6b1931 master     -> origin/master  (forced update)
   7b7adc4..a952baa  stable     -> origin/stable
 * [new tag]         next-20110321 -> next-20110321
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    832502 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1552 - % of code consists of backport work
