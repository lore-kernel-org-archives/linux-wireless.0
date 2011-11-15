Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:39963 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932318Ab1KOVMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 16:12:10 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id 1FD2154019D
	for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2011 16:35:59 -0500 (EST)
Subject: Compat-wireless release for 2011-11-15 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20111115211208.CEE3740633@repository3.orbit-lab.org> (sfid-20111115_221214_836139_2181B227)
Date: Tue, 15 Nov 2011 16:12:08 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://github.com/mcgrof/compat-wireless
   06d5dce..158ed6d  linux-3.0.y -> origin/linux-3.0.y
   211b54a..aba822c  linux-3.1.y -> origin/linux-3.1.y
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + e45f8b4...6cf8074 akpm-end   -> origin/akpm-end  (forced update)
   52e4c2a..7f80850  akpm-start -> origin/akpm-start
 + a51a24e...5be1fb2 master     -> origin/master  (forced update)
   52e4c2a..7f80850  stable     -> origin/stable
 * [new tag]         next-20111115 -> next-20111115

compat-wireless code metrics

    816892 - Total upstream lines of code being pulled
      2492 - backport code changes
      2146 - backport code additions
       346 - backport code deletions
      8671 - backport from compat module
     11163 - total backport code
    1.3665 - % of code consists of backport work
