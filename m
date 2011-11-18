Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:41709 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753152Ab1KRVM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 16:12:29 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 218385401EF
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 16:36:59 -0500 (EST)
Subject: Compat-wireless release for 2011-11-18 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111118211227.5D67040633@repository3.orbit-lab.org> (sfid-20111118_221240_671350_D09B946C)
Date: Fri, 18 Nov 2011 16:12:27 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://github.com/mcgrof/compat-wireless
   4ab9b62..d32558f  master     -> origin/master
>From git://github.com/mcgrof/compat
   1beb89b..38eb59d  linux-3.2.y -> origin/linux-3.2.y
   1beb89b..47605df  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 34de998...04be1f1 akpm-end   -> origin/akpm-end  (forced update)
   6aaf05f..a9098b3  akpm-start -> origin/akpm-start
 + 518b3de...fdf6edf master     -> origin/master  (forced update)
   6aaf05f..a9098b3  stable     -> origin/stable
 * [new tag]         next-20111118 -> next-20111118

compat-wireless code metrics

    819371 - Total upstream lines of code being pulled
      2455 - backport code changes
      2110 - backport code additions
       345 - backport code deletions
      8770 - backport from compat module
     11225 - total backport code
    1.3700 - % of code consists of backport work
