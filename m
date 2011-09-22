Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:44410 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751370Ab1IVTEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 15:04:52 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 96AC25401A7
	for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 15:17:51 -0400 (EDT)
Subject: Compat-wireless release for 2011-09-22 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110922190451.3DE1F40647@repository3.orbit-lab.org> (sfid-20110922_210500_142631_12931C59)
Date: Thu, 22 Sep 2011 15:04:51 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://github.com/mcgrof/compat-wireless
   a898f60..5904b94  master     -> origin/master
>From git://github.com/mcgrof/compat
   0808fea..8331446  master     -> origin/master
>From git://github.com/sfrothwell/linux-next
 + 39fc525...4deee6e akpm-end   -> origin/akpm-end  (forced update)
   38867a2..d93dc5c  akpm-start -> origin/akpm-start
 + 367fd59...c4d76b4 master     -> origin/master  (forced update)
   38867a2..d93dc5c  stable     -> origin/stable
 * [new tag]         next-20110922 -> next-20110922
 * [new tag]         v3.1-rc7   -> v3.1-rc7

compat-wireless code metrics

    812386 - Total upstream lines of code being pulled
      2397 - backport code changes
      2086 - backport code additions
       311 - backport code deletions
      8538 - backport from compat module
     10935 - total backport code
    1.3460 - % of code consists of backport work
Host key verification failed.
rsync: connection unexpectedly closed (0 bytes received so far) [sender]
rsync error: unexplained error (code 255) at io.c(601) [sender=3.0.7]
