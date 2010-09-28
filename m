Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:37542 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753930Ab0I1TDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 15:03:45 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 028C2418D8
	for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 15:01:31 -0400 (EDT)
Subject: Compat-wireless release for 2010-09-28 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20100928190344.07D04404FC@repository3.orbit-lab.org>
Date: Tue, 28 Sep 2010 15:03:43 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   84ac593..f2e8f16  linux-2.6.36.y -> origin/linux-2.6.36.y
   96d9e6e..c735ecb  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
 * [new tag]         compat-wireless-v2.6.36-rc5-1 -> compat-wireless-v2.6.36-rc5-1
 * [new tag]         compat-wireless-v2.6.36-rc5-2 -> compat-wireless-v2.6.36-rc5-2
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   edd6839..b7b3dc6  history    -> origin/history
 + 35b3f2c...ac8f1ff master     -> origin/master  (forced update)
   32163f4..252a52a  stable     -> origin/stable
 * [new tag]         next-20100928 -> next-20100928

compat-wireless code metrics

    747601 - Total upstream lines of code being pulled
      2153 - backport code changes
      1902 - backport code additions
       251 - backport code deletions
      6242 - backport from compat module
      8395 - total backport code
    1.1229 - % of code consists of backport work
      1219 - Crap changes not yet posted
      1181 - Crap additions not yet posted
        38 - Crap deletions not yet posted
    0.1631 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100928
compat-wireless release: compat-wireless-2010-09-27-8-gc735ecb-pc
