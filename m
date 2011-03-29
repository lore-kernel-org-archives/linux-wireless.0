Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:46139 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750942Ab1C2TFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 15:05:32 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 220095401D1
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 15:09:47 -0400 (EDT)
Subject: Compat-wireless release for 2011-03-29 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110329190531.41C7140EAB@repository3.orbit-lab.org>
Date: Tue, 29 Mar 2011 15:05:31 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 2c348fb...55370d9 akpm-end   -> origin/akpm-end  (forced update)
   16c29da..036a982  akpm-start -> origin/akpm-start
   e5ca460..48aa660  history    -> origin/history
 + 285d731...74bdbee master     -> origin/master  (forced update)
   16c29da..036a982  stable     -> origin/stable
 * [new tag]         next-20110329 -> next-20110329
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    832907 - Total upstream lines of code being pulled
      2175 - backport code changes
      1891 - backport code additions
       284 - backport code deletions
      7442 - backport from compat module
      9617 - total backport code
    1.1546 - % of code consists of backport work
