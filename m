Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:46410 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932346Ab1EaTDw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:03:52 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id A2CDA5403F4
	for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 15:10:16 -0400 (EDT)
Subject: Compat-wireless release for 2011-05-31 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110531190350.EF43440EB8@repository3.orbit-lab.org> (sfid-20110531_210404_997966_64730093)
Date: Tue, 31 May 2011 15:03:50 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new branch]      linux-3.0.0.y -> origin/linux-3.0.0.y
 * [new branch]      linux-3.0.y -> origin/linux-3.0.y
 * [new tag]         compat-wireless-v3.0-rc1 -> compat-wireless-v3.0-rc1
 * [new tag]         compat-wireless-v3.0-rc1-1 -> compat-wireless-v3.0-rc1-1
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
 * [new branch]      linux-3.0.0.y -> origin/linux-3.0.0.y
 * [new tag]         compat-v3.0-1 -> compat-v3.0-1
 * [new tag]         compat-v3.0-2 -> compat-v3.0-2
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 81cd8a9...3f921c6 akpm-end   -> origin/akpm-end  (forced update)
   7fd96ba..9185b01  history    -> origin/history
 + e2cf001...25c5fa8 master     -> origin/master  (forced update)
 * [new tag]         next-20110531 -> next-20110531

compat-wireless code metrics

    823149 - Total upstream lines of code being pulled
      2394 - backport code changes
      2086 - backport code additions
       308 - backport code deletions
      8070 - backport from compat module
     10464 - total backport code
    1.2712 - % of code consists of backport work
