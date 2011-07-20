Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:54836 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751418Ab1GTTFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 15:05:33 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 17AEB542477
	for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 15:13:43 -0400 (EDT)
Subject: Compat-wireless release for 2011-07-20 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110720190531.8066340ECC@repository3.orbit-lab.org> (sfid-20110720_210536_076525_09FC71C1)
Date: Wed, 20 Jul 2011 15:05:31 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   89a736d..0ceab01  master     -> origin/master
 * [new tag]         compat-wireless-2011-07-19 -> compat-wireless-2011-07-19
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   7d35284..88ffc8d  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 70274bc...331eea6 akpm-end   -> origin/akpm-end  (forced update)
   f560f66..3a5c374  akpm-start -> origin/akpm-start
   51fb176..f9b4b6c  history    -> origin/history
 + 1e36867...5d40945 master     -> origin/master  (forced update)
   f560f66..3a5c374  stable     -> origin/stable
 * [new tag]         next-20110720 -> next-20110720

compat-wireless code metrics

    834601 - Total upstream lines of code being pulled
      2390 - backport code changes
      2085 - backport code additions
       305 - backport code deletions
      8158 - backport from compat module
     10548 - total backport code
    1.2638 - % of code consists of backport work
