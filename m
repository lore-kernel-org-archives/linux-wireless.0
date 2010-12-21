Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:47166 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751006Ab0LUUOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 15:14:42 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 95C374061F
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 15:14:57 -0500 (EST)
Subject: Compat-wireless release for 2010-12-21 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101221201441.2EF8140F97@repository3.orbit-lab.org>
Date: Tue, 21 Dec 2010 15:14:41 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   af01533..52e96b5  linux-2.6.37.y -> origin/linux-2.6.37.y
 * [new tag]         compat-wireless-v2.6.37-rc6-1 -> compat-wireless-v2.6.37-rc6-1
fatal: The remote end hung up unexpectedly
fatal: protocol error: bad pack header

compat-wireless code metrics

    777014 - Total upstream lines of code being pulled
      2223 - backport code changes
      1946 - backport code additions
       277 - backport code deletions
      6669 - backport from compat module
      8892 - total backport code
    1.1444 - % of code consists of backport work
      1532 - Crap changes not yet posted
      1489 - Crap additions not yet posted
        43 - Crap deletions not yet posted
    0.1972 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101220
compat-wireless release: compat-wireless-2010-12-20-pc
