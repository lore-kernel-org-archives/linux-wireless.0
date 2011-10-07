Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:58154 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753703Ab1JGTEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 15:04:53 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 656D454022F
	for <linux-wireless@vger.kernel.org>; Fri,  7 Oct 2011 15:18:47 -0400 (EDT)
Subject: Compat-wireless release for 2011-10-07 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111007190451.F15F740650@repository3.orbit-lab.org> (sfid-20111007_210456_857207_E04E4237)
Date: Fri,  7 Oct 2011 15:04:51 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://github.com/mcgrof/compat-wireless
   e4f1a17..8163a60  master     -> origin/master
>From git://github.com/sfrothwell/linux-next
 + 98b3e8f...186cf8e akpm-end   -> origin/akpm-end  (forced update)
   538d288..3ee72ca  akpm-start -> origin/akpm-start
 + 40a33ae...12d1b9a master     -> origin/master  (forced update)
   538d288..3ee72ca  stable     -> origin/stable
 * [new tag]         next-20111007 -> next-20111007

compat-wireless code metrics

    811845 - Total upstream lines of code being pulled
      2431 - backport code changes
      2113 - backport code additions
       318 - backport code deletions
      8588 - backport from compat module
     11019 - total backport code
    1.3573 - % of code consists of backport work
