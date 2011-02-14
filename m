Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:42024 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752569Ab1BNUHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 15:07:05 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id DD80E54017F
	for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 15:09:52 -0500 (EST)
Subject: Compat-wireless release for 2011-02-14 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110214200704.0F281434AE@repository3.orbit-lab.org>
Date: Mon, 14 Feb 2011 15:07:03 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + f26e68f...6d48219 akpm-end   -> origin/akpm-end  (forced update)
   67d0195..091994c  akpm-start -> origin/akpm-start
   13a1f7a..c4286b3  history    -> origin/history
 + c71f8b8...6a658e2 master     -> origin/master  (forced update)
   67d0195..091994c  stable     -> origin/stable
 * [new tag]         next-20110214 -> next-20110214
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    787076 - Total upstream lines of code being pulled
      2093 - backport code changes
      1831 - backport code additions
       262 - backport code deletions
      7292 - backport from compat module
      9385 - total backport code
    1.1924 - % of code consists of backport work
