Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:55908 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751365Ab1BPUHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 15:07:10 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 2BD4A5401D1
	for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 15:10:02 -0500 (EST)
Subject: Compat-wireless release for 2011-02-16 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110216200709.21FD0434D6@repository3.orbit-lab.org>
Date: Wed, 16 Feb 2011 15:07:08 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + a57cb3b...b205214 akpm-end   -> origin/akpm-end  (forced update)
   795abaf..b90be86  akpm-start -> origin/akpm-start
   1136027..47db34d  history    -> origin/history
 + b7bbcc2...f54bb7e master     -> origin/master  (forced update)
   795abaf..b90be86  stable     -> origin/stable
 * [new tag]         next-20110216 -> next-20110216
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    787872 - Total upstream lines of code being pulled
      2093 - backport code changes
      1831 - backport code additions
       262 - backport code deletions
      7292 - backport from compat module
      9385 - total backport code
    1.1912 - % of code consists of backport work
