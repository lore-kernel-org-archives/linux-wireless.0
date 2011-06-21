Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:38391 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757310Ab1FUTE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 15:04:57 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id A5D285401D1
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 15:12:05 -0400 (EDT)
Subject: Compat-wireless release for 2011-06-21 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110621190455.7E3EC40EC8@repository3.orbit-lab.org> (sfid-20110621_210513_574688_B067B899)
Date: Tue, 21 Jun 2011 15:04:55 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   0a1c49d..53583b5  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + b3793c4...0ea2a56 akpm-end   -> origin/akpm-end  (forced update)
   de505e7..ef46222  akpm-start -> origin/akpm-start
   67a9b28..0cb9206  history    -> origin/history
 + 229f40f...775ad65 master     -> origin/master  (forced update)
   de505e7..ef46222  stable     -> origin/stable
 * [new tag]         next-20110621 -> next-20110621

compat-wireless code metrics

    820364 - Total upstream lines of code being pulled
      2385 - backport code changes
      2078 - backport code additions
       307 - backport code deletions
      8123 - backport from compat module
     10508 - total backport code
    1.2809 - % of code consists of backport work
