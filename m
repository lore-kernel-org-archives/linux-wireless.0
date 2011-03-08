Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:48000 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755447Ab1CHUGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 15:06:33 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 812695401CC
	for <linux-wireless@vger.kernel.org>; Tue,  8 Mar 2011 15:10:05 -0500 (EST)
Subject: Compat-wireless release for 2011-03-08 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110308200631.BA07645935@repository3.orbit-lab.org>
Date: Tue,  8 Mar 2011 15:06:31 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + abdd788...e110091 akpm-end   -> origin/akpm-end  (forced update)
   fb62c00..214d93b  akpm-start -> origin/akpm-start
   2ad4b4f..4e20f6f  history    -> origin/history
 + c45165c...50dc6c3 master     -> origin/master  (forced update)
   fb62c00..214d93b  stable     -> origin/stable
 * [new tag]         next-20110308 -> next-20110308
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    831955 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1560 - % of code consists of backport work
