Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:53644 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755378Ab0LBUEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 15:04:35 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id DE8FC418D8
	for <linux-wireless@vger.kernel.org>; Thu,  2 Dec 2010 14:59:27 -0500 (EST)
Subject: Compat-wireless release for 2010-12-02 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20101202200434.BCA8740F97@repository3.orbit-lab.org>
Date: Thu,  2 Dec 2010 15:04:34 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
   efeeae7..813c0e6  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat
   53f0279..65ac8aa  master     -> origin/master
>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
   1a3c19a..c9f50b7  history    -> origin/history
 + 87565f31...80efa21 master     -> origin/master  (forced update)
   e8a7e48..22a5b56  stable     -> origin/stable
 * [new tag]         next-20101202 -> next-20101202
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    749790 - Total upstream lines of code being pulled
      2201 - backport code changes
      1939 - backport code additions
       262 - backport code deletions
      6637 - backport from compat module
      8838 - total backport code
    1.1787 - % of code consists of backport work
      1534 - Crap changes not yet posted
      1491 - Crap additions not yet posted
        43 - Crap deletions not yet posted
    0.2046 - % of crap code

Base tree: linux-next.git
Base tree version: next-20101202
compat-wireless release: compat-wireless-2010-11-23-7-g813c0e6-pc
