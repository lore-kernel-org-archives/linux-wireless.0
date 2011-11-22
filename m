Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:52376 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753130Ab1KVVM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 16:12:26 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id BB5CE540302
	for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 16:37:51 -0500 (EST)
Subject: Compat-wireless release for 2011-11-22 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111122211224.9EDC840634@repository3.orbit-lab.org> (sfid-20111122_221229_273881_19195641)
Date: Tue, 22 Nov 2011 16:12:24 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 80d9ddd...ba3563b akpm-end   -> origin/akpm-end  (forced update)
   a767835..f8f5ed7  akpm-start -> origin/akpm-start
 + bd87c6c...4951853 master     -> origin/master  (forced update)
   a767835..f8f5ed7  stable     -> origin/stable
 * [new tag]         next-20111122 -> next-20111122

compat-wireless code metrics

    819430 - Total upstream lines of code being pulled
      2455 - backport code changes
      2110 - backport code additions
       345 - backport code deletions
      8770 - backport from compat module
     11225 - total backport code
    1.3699 - % of code consists of backport work
