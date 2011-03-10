Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:59069 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752833Ab1CJUGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 15:06:38 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id CE40754017F
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 15:10:14 -0500 (EST)
Subject: Compat-wireless release for 2011-03-10 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110310200637.0AF1440E8F@repository3.orbit-lab.org>
Date: Thu, 10 Mar 2011 15:06:36 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 9cfa781...a6aeafb akpm-end   -> origin/akpm-end  (forced update)
   a5abba9..3979491  akpm-start -> origin/akpm-start
   71aaf6b..3a91f09  history    -> origin/history
 + ab200f7...d1f497c master     -> origin/master  (forced update)
   a5abba9..3979491  stable     -> origin/stable
 * [new tag]         next-20110310 -> next-20110310
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    831967 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1559 - % of code consists of backport work
