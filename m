Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:52930 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751584Ab1LBVMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 16:12:33 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 7462D540302
	for <linux-wireless@vger.kernel.org>; Fri,  2 Dec 2011 16:12:32 -0500 (EST)
Subject: Compat-wireless release for 2011-12-02 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111202211232.4D9BA40626@repository3.orbit-lab.org> (sfid-20111202_221236_604759_24EEA332)
Date: Fri,  2 Dec 2011 16:12:32 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://github.com/mcgrof/compat
   545ece9..0c51ea9  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 0538222...f4cd1a2 akpm-end   -> origin/akpm-end  (forced update)
   883381d..b930c26  akpm-start -> origin/akpm-start
 + 3114bdf...e2dec20 master     -> origin/master  (forced update)
   883381d..b930c26  stable     -> origin/stable
 * [new tag]         next-20111202 -> next-20111202

compat-wireless code metrics

    822489 - Total upstream lines of code being pulled
      2449 - backport code changes
      2107 - backport code additions
       342 - backport code deletions
      8841 - backport from compat module
     11290 - total backport code
    1.3727 - % of code consists of backport work
