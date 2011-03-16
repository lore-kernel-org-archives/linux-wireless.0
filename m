Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:35407 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750951Ab1CPTG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 15:06:57 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id D985654017C
	for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 15:10:45 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-16 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110316190656.0558240EA9@repository3.orbit-lab.org>
Date: Wed, 16 Mar 2011 15:06:55 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 68e17d8...19f72f1 akpm-end   -> origin/akpm-end  (forced update)
   dc1b83a..76ca078  akpm-start -> origin/akpm-start
   e3786d7..22c1b5a  history    -> origin/history
 + f69358a...3cf254e master     -> origin/master  (forced update)
   dc1b83a..76ca078  stable     -> origin/stable
 * [new tag]         next-20110316 -> next-20110316
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 * [new tag]         v2.6.38    -> v2.6.38
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
