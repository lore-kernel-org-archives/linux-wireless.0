Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:59964 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753267Ab1LFVMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 16:12:52 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id F1A4E540189
	for <linux-wireless@vger.kernel.org>; Tue,  6 Dec 2011 16:12:50 -0500 (EST)
Subject: Compat-wireless release for 2011-12-06 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111206211247.A9CF74062F@repository3.orbit-lab.org> (sfid-20111206_221255_743044_EB87FC8E)
Date: Tue,  6 Dec 2011 16:12:46 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://github.com/mcgrof/compat
   0c51ea9..984ab77  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + f4cd1a2...a6a9ce3 akpm-end   -> origin/akpm-end  (forced update)
   b930c26..8e8da02  akpm-start -> origin/akpm-start
 + e2dec20...9c2d96c master     -> origin/master  (forced update)
   b930c26..8e8da02  stable     -> origin/stable
 * [new tag]         next-20111206 -> next-20111206
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 * [new tag]         v3.2-rc4   -> v3.2-rc4

compat-wireless code metrics

    822582 - Total upstream lines of code being pulled
      2470 - backport code changes
      2122 - backport code additions
       348 - backport code deletions
      8885 - backport from compat module
     11355 - total backport code
    1.3804 - % of code consists of backport work
