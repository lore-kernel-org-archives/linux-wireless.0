Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:46994 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753634Ab1HZTFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 15:05:19 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 52643540237
	for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 15:14:38 -0400 (EDT)
Subject: Compat-wireless release for 2011-08-26 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110826190518.004D240631@repository3.orbit-lab.org> (sfid-20110826_210523_194484_CE11D042)
Date: Fri, 26 Aug 2011 15:05:17 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   3e4dd06..d32228d  master     -> origin/master
 * [new tag]         compat-wireless-2011-08-25 -> compat-wireless-2011-08-25
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   55a12f9..40f7615  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 27a730b...da24751 akpm-end   -> origin/akpm-end  (forced update)
   caca951..b4ca46e  akpm-start -> origin/akpm-start
 + 0060a16...fa16964 master     -> origin/master  (forced update)
   caca951..b4ca46e  stable     -> origin/stable
 * [new tag]         next-20110826 -> next-20110826

compat-wireless code metrics

    803468 - Total upstream lines of code being pulled
      2397 - backport code changes
      2086 - backport code additions
       311 - backport code deletions
      8431 - backport from compat module
     10828 - total backport code
    1.3477 - % of code consists of backport work
