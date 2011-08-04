Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:41455 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754540Ab1HDTEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 15:04:22 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 14F03540055
	for <linux-wireless@vger.kernel.org>; Thu,  4 Aug 2011 15:13:04 -0400 (EDT)
Subject: Compat-wireless release for 2011-08-04 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110804190420.B470A40ED4@repository3.orbit-lab.org> (sfid-20110804_210424_915399_2108AE54)
Date: Thu,  4 Aug 2011 15:04:20 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 0b0ed41...acc40a7 akpm-end   -> origin/akpm-end  (forced update)
   c027a47..ed8f373  akpm-start -> origin/akpm-start
 + 8d79bd3...94edca8 master     -> origin/master  (forced update)
   c027a47..ed8f373  stable     -> origin/stable
 * [new tag]         next-20110804 -> next-20110804

compat-wireless code metrics

    835398 - Total upstream lines of code being pulled
      2400 - backport code changes
      2094 - backport code additions
       306 - backport code deletions
      8182 - backport from compat module
     10582 - total backport code
    1.2667 - % of code consists of backport work
