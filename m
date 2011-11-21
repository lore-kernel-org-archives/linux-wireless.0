Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:43149 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751103Ab1KUVMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 16:12:39 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id BDA9454044A
	for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 16:37:50 -0500 (EST)
Subject: Compat-wireless release for 2011-11-21 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111121211237.794164062E@repository3.orbit-lab.org> (sfid-20111121_221242_666977_B4CB2237)
Date: Mon, 21 Nov 2011 16:12:37 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 04be1f1...80d9ddd akpm-end   -> origin/akpm-end  (forced update)
   a9098b3..a767835  akpm-start -> origin/akpm-start
 + fdf6edf...bd87c6c master     -> origin/master  (forced update)
   a9098b3..a767835  stable     -> origin/stable
 * [new tag]         next-20111121 -> next-20111121

compat-wireless code metrics

    819372 - Total upstream lines of code being pulled
      2455 - backport code changes
      2110 - backport code additions
       345 - backport code deletions
      8770 - backport from compat module
     11225 - total backport code
    1.3700 - % of code consists of backport work
