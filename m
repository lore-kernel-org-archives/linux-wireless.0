Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:59637 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751831Ab1CYTFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 15:05:53 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 441CB5403BC
	for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2011 15:10:00 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-25 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110325190552.5C8C140EAB@repository3.orbit-lab.org>
Date: Fri, 25 Mar 2011 15:05:52 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + e3ec91f...f1829e8 akpm-end   -> origin/akpm-end  (forced update)
   4bbba11..d39dd11  akpm-start -> origin/akpm-start
   06d6614..d820e1b  history    -> origin/history
 + 0af3dae...380d3c6 master     -> origin/master  (forced update)
   4bbba11..d39dd11  stable     -> origin/stable
 * [new tag]         next-20110325 -> next-20110325
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    832860 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1547 - % of code consists of backport work
