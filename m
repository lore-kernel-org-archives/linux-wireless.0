Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:57850 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755381Ab1BOUHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 15:07:20 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 84C0E540110
	for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 15:10:09 -0500 (EST)
Subject: Compat-wireless release for 2011-02-15 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110215200718.A8F75434BE@repository3.orbit-lab.org>
Date: Tue, 15 Feb 2011 15:07:18 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 6d48219...a57cb3b akpm-end   -> origin/akpm-end  (forced update)
   091994c..795abaf  akpm-start -> origin/akpm-start
   c4286b3..1136027  history    -> origin/history
 + 6a658e2...b7bbcc2 master     -> origin/master  (forced update)
   091994c..795abaf  stable     -> origin/stable
 * [new tag]         next-20110215 -> next-20110215
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    787333 - Total upstream lines of code being pulled
      2093 - backport code changes
      1831 - backport code additions
       262 - backport code deletions
      7292 - backport from compat module
      9385 - total backport code
    1.1920 - % of code consists of backport work
