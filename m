Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:50080 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751580Ab1KIVMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 16:12:22 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id F222954019F
	for <linux-wireless@vger.kernel.org>; Wed,  9 Nov 2011 16:34:39 -0500 (EST)
Subject: Compat-wireless release for 2011-11-09 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111109211220.5AFEB40625@repository3.orbit-lab.org> (sfid-20111109_221225_970774_7B312886)
Date: Wed,  9 Nov 2011 16:12:20 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + 033ff8c...f491bf2 akpm-end   -> origin/akpm-end  (forced update)
   1ea6b8f..3b75462  akpm-start -> origin/akpm-start
 + 15851cc...fc658de master     -> origin/master  (forced update)
   1ea6b8f..3b75462  stable     -> origin/stable
 * [new tag]         next-20111109 -> next-20111109

compat-wireless code metrics

    815459 - Total upstream lines of code being pulled
      2488 - backport code changes
      2143 - backport code additions
       345 - backport code deletions
      8650 - backport from compat module
     11138 - total backport code
    1.3659 - % of code consists of backport work
