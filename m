Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:59933 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933399Ab1D1TFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 15:05:41 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id C164B540188
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 15:10:54 -0400 (EDT)
Subject: Compat-wireless release for 2011-04-28 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110428190538.8D70140EBB@repository3.orbit-lab.org> (sfid-20110428_210545_820111_55510C50)
Date: Thu, 28 Apr 2011 15:05:38 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   37ffaa7..b2299b6  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + d0fda73...9b64b93 akpm-end   -> origin/akpm-end  (forced update)
   4175242..e8dad69  akpm-start -> origin/akpm-start
   8be0895..f21600e  history    -> origin/history
 + 084d224...bfb7306 master     -> origin/master  (forced update)
   4175242..e8dad69  stable     -> origin/stable
 * [new tag]         next-20110428 -> next-20110428
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 * [new tag]         v2.6.39-rc5 -> v2.6.39-rc5

compat-wireless code metrics

    845476 - Total upstream lines of code being pulled
      2355 - backport code changes
      2048 - backport code additions
       307 - backport code deletions
      8033 - backport from compat module
     10388 - total backport code
    1.2287 - % of code consists of backport work
