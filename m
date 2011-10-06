Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:38962 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759033Ab1JFTEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:04:49 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 014EB5403E8
	for <linux-wireless@vger.kernel.org>; Thu,  6 Oct 2011 15:18:27 -0400 (EDT)
Subject: Compat-wireless release for 2011-10-06 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111006190442.53FBF40650@repository3.orbit-lab.org> (sfid-20111006_210453_448957_0806AC20)
Date: Thu,  6 Oct 2011 15:04:42 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://github.com/mcgrof/compat-wireless
   2309ddb..e4f1a17  master     -> origin/master
>From git://github.com/mcgrof/compat
   966e847..b5edac3  master     -> origin/master
>From git://github.com/sfrothwell/linux-next
 + a2851f2...98b3e8f akpm-end   -> origin/akpm-end  (forced update)
   a8062e4..538d288  akpm-start -> origin/akpm-start
 + 09d70e2...40a33ae master     -> origin/master  (forced update)
   a8062e4..538d288  stable     -> origin/stable
 * [new tag]         next-20111006 -> next-20111006
>From git://github.com/sfrothwell/linux-next
 * [new tag]         v3.1-rc9   -> v3.1-rc9

compat-wireless code metrics

    811845 - Total upstream lines of code being pulled
      2413 - backport code changes
      2097 - backport code additions
       316 - backport code deletions
      8588 - backport from compat module
     11001 - total backport code
    1.3551 - % of code consists of backport work
Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
rsync: connection unexpectedly closed (0 bytes received so far) [sender]
rsync error: unexplained error (code 255) at io.c(601) [sender=3.0.7]
