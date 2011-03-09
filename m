Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:53894 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751953Ab1CIUHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 15:07:14 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 0F0D55400B5
	for <linux-wireless@vger.kernel.org>; Wed,  9 Mar 2011 15:10:48 -0500 (EST)
Subject: Compat-wireless release for 2011-03-09 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110309200712.3F40040E8E@repository3.orbit-lab.org>
Date: Wed,  9 Mar 2011 15:07:12 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + e110091...9cfa781 akpm-end   -> origin/akpm-end  (forced update)
   214d93b..a5abba9  akpm-start -> origin/akpm-start
   4e20f6f..71aaf6b  history    -> origin/history
 + 50dc6c3...ab200f7 master     -> origin/master  (forced update)
   214d93b..a5abba9  stable     -> origin/stable
 * [new tag]         next-20110309 -> next-20110309
 * [new tag]         v2.6.38-rc8 -> v2.6.38-rc8
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
