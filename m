Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:38446 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756771Ab1CRTG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 15:06:28 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id E232F540175
	for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 15:10:19 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-18 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110318190626.17F3B40EA9@repository3.orbit-lab.org>
Date: Fri, 18 Mar 2011 15:06:26 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   6e19bea..8490f74  linux-2.6.38.y -> origin/linux-2.6.38.y
 * [new tag]         compat-wireless-2.6.38-3 -> compat-wireless-2.6.38-3
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 1eae6a8...ede9e56 akpm-end   -> origin/akpm-end  (forced update)
   2e270d8..7b7adc4  akpm-start -> origin/akpm-start
   e413425..56c7693  history    -> origin/history
 + f603315...1a94657 master     -> origin/master  (forced update)
   2e270d8..7b7adc4  stable     -> origin/stable
 * [new tag]         next-20110318 -> next-20110318
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
