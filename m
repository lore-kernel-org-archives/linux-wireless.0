Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:48881 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753845Ab1HETEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 15:04:32 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id B4F07540055
	for <linux-wireless@vger.kernel.org>; Fri,  5 Aug 2011 15:13:16 -0400 (EDT)
Subject: Compat-wireless release for 2011-08-05 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110805190431.40BD240ED4@repository3.orbit-lab.org> (sfid-20110805_210441_195406_159BFF5D)
Date: Fri,  5 Aug 2011 15:04:28 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + acc40a7...a05e18f akpm-end   -> origin/akpm-end  (forced update)
   ed8f373..53d1e65  akpm-start -> origin/akpm-start
 + 94edca8...3927df3 master     -> origin/master  (forced update)
   ed8f373..53d1e65  stable     -> origin/stable
 * [new tag]         next-20110805 -> next-20110805

compat-wireless code metrics

    835398 - Total upstream lines of code being pulled
      2400 - backport code changes
      2094 - backport code additions
       306 - backport code deletions
      8182 - backport from compat module
     10582 - total backport code
    1.2667 - % of code consists of backport work
