Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:47804 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754842Ab1JNTFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 15:05:11 -0400
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 3C5585402CB
	for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 15:20:52 -0400 (EDT)
Subject: Compat-wireless release for 2011-10-14 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111014190510.521E940659@repository3.orbit-lab.org> (sfid-20111014_210516_009046_14A501B1)
Date: Fri, 14 Oct 2011 15:05:10 -0400 (EDT)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://github.com/mcgrof/compat-wireless
   8163a60..49eb82e  master     -> origin/master
>From git://github.com/sfrothwell/linux-next
 + 53c998a...0bb9d7e akpm-end   -> origin/akpm-end  (forced update)
   65112dc..37cf951  akpm-start -> origin/akpm-start
 + 7b64d23...970cc26 master     -> origin/master  (forced update)
   65112dc..37cf951  stable     -> origin/stable
 * [new tag]         next-20111014 -> next-20111014

compat-wireless code metrics

    814119 - Total upstream lines of code being pulled
      2431 - backport code changes
      2113 - backport code additions
       318 - backport code deletions
      8588 - backport from compat module
     11019 - total backport code
    1.3535 - % of code consists of backport work
