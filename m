Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:48613 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756158Ab1CWTEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:04:33 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 691C7540154
	for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 15:08:35 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-23 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110323190431.8671B40EAB@repository3.orbit-lab.org>
Date: Wed, 23 Mar 2011 15:04:31 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 5fe0ac7...9e4bf51 akpm-end   -> origin/akpm-end  (forced update)
   eddecbb..f741a79  akpm-start -> origin/akpm-start
   c3db6d4..bef03cd  history    -> origin/history
 + 63c90db...601607a master     -> origin/master  (forced update)
   eddecbb..f741a79  stable     -> origin/stable
 * [new tag]         next-20110323 -> next-20110323
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
