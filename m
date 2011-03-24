Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:51425 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757014Ab1CXTEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 15:04:46 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 98F5C5401D6
	for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 15:08:49 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-24 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110324190443.BA72640EAB@repository3.orbit-lab.org>
Date: Thu, 24 Mar 2011 15:04:43 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 9e4bf51...e3ec91f akpm-end   -> origin/akpm-end  (forced update)
   f741a79..4bbba11  akpm-start -> origin/akpm-start
   bef03cd..06d6614  history    -> origin/history
 + 601607a...0af3dae master     -> origin/master  (forced update)
   f741a79..4bbba11  stable     -> origin/stable
 * [new tag]         next-20110324 -> next-20110324
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    832517 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1552 - % of code consists of backport work
