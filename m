Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:42646 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751424Ab1LHVMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 16:12:37 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 0A641540575
	for <linux-wireless@vger.kernel.org>; Thu,  8 Dec 2011 16:12:36 -0500 (EST)
Subject: Compat-wireless release for 2011-12-08 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111208211235.D90224062E@repository3.orbit-lab.org> (sfid-20111208_221240_549259_80989028)
Date: Thu,  8 Dec 2011 16:12:35 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 3a0aa65...8a1b854 akpm-end   -> origin/akpm-end  (forced update)
   b835c0f..77a7300a akpm-start -> origin/akpm-start
 + 84577d6...ecae3979 master     -> origin/master  (forced update)
   b835c0f..77a7300a stable     -> origin/stable
 * [new tag]         next-20111208 -> next-20111208

compat-wireless code metrics

    822905 - Total upstream lines of code being pulled
      2470 - backport code changes
      2122 - backport code additions
       348 - backport code deletions
      8885 - backport from compat module
     11355 - total backport code
    1.3799 - % of code consists of backport work
