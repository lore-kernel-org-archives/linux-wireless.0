Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:40131 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752990Ab1F2TFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 15:05:01 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id B4D11540055
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 15:12:27 -0400 (EDT)
Subject: Compat-wireless release for 2011-06-29 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110629190500.9C63240EC7@repository3.orbit-lab.org> (sfid-20110629_210509_158698_2984EA9F)
Date: Wed, 29 Jun 2011 15:05:00 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   ce3bc79..89a736d  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 7b31fe9...28c9310 akpm-end   -> origin/akpm-end  (forced update)
 + 04c93b7...b0af8df akpm-start -> origin/akpm-start  (forced update)
   de335a4..b0e1893  history    -> origin/history
 + ff28b39...3c2ce3e master     -> origin/master  (forced update)
   4d258b2..b0af8df  stable     -> origin/stable
 * [new tag]         next-20110629 -> next-20110629
 * [new tag]         v3.0-rc5   -> v3.0-rc5

compat-wireless code metrics

    838787 - Total upstream lines of code being pulled
      2380 - backport code changes
      2080 - backport code additions
       300 - backport code deletions
      8125 - backport from compat module
     10505 - total backport code
    1.2524 - % of code consists of backport work
