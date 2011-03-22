Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:51741 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751338Ab1CVTET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 15:04:19 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 7CB81540154
	for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 15:08:20 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-22 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110322190418.A336D40EAA@repository3.orbit-lab.org>
Date: Tue, 22 Mar 2011 15:04:18 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + d7f2ee7...5fe0ac7 akpm-end   -> origin/akpm-end  (forced update)
   a952baa..eddecbb  akpm-start -> origin/akpm-start
   29bb428..c3db6d4  history    -> origin/history
 + d6b1931...63c90db master     -> origin/master  (forced update)
   a952baa..eddecbb  stable     -> origin/stable
 * [new tag]         next-20110322 -> next-20110322
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    832512 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1552 - % of code consists of backport work
