Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:54051 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754568Ab1HCTHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 15:07:48 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id F19E25401C6
	for <linux-wireless@vger.kernel.org>; Wed,  3 Aug 2011 15:16:27 -0400 (EDT)
Subject: Compat-wireless release for 2011-08-03 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110803190746.AF9ED40ED4@repository3.orbit-lab.org> (sfid-20110803_210751_604633_06425784)
Date: Wed,  3 Aug 2011 15:07:46 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   72e6376..9276969  master     -> origin/master
git.kernel.org[0: 149.20.20.136]: errno=Connection timed out
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   468b47d..29f7643  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 64b0481...0b0ed41 akpm-end   -> origin/akpm-end  (forced update)
   cfe2234..c027a47  akpm-start -> origin/akpm-start
 + c2ad60b...8d79bd3 master     -> origin/master  (forced update)
   cfe2234..c027a47  stable     -> origin/stable
 * [new tag]         next-20110803 -> next-20110803

compat-wireless code metrics

    835398 - Total upstream lines of code being pulled
      2400 - backport code changes
      2094 - backport code additions
       306 - backport code deletions
      8182 - backport from compat module
     10582 - total backport code
    1.2667 - % of code consists of backport work
