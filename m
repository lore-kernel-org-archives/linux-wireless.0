Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from external1.orbit-lab.org ([128.6.192.131]:34395 "HELO
	external1.orbit-lab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756989Ab1BKUH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 15:07:27 -0500
Received: from repository3.orbit-lab.org (repository3.orbit-lab.org [10.50.0.41])
	by external1.orbit-lab.org (Postfix) with ESMTP id D991454003E
	for <linux-wireless@vger.kernel.org>; Fri, 11 Feb 2011 15:10:08 -0500 (EST)
Subject: Compat-wireless release for 2011-02-11 is baked
To: <linux-wireless@vger.kernel.org>
Message-Id: <20110211200726.6E76442F5C@repository3.orbit-lab.org>
Date: Fri, 11 Feb 2011 15:07:26 -0500 (EST)
From: compat@orbit-lab.org (Compat-wireless cronjob account)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
 + fe668b0...f26e68f akpm-end   -> origin/akpm-end  (forced update)
   d3d373e..67d0195  akpm-start -> origin/akpm-start
   90bf504..13a1f7a  history    -> origin/history
 + d409db5...c71f8b8 master     -> origin/master  (forced update)
   d3d373e..67d0195  stable     -> origin/stable
 * [new tag]         next-20110211 -> next-20110211
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
cat: compat_base_tree: No such file or directory
cat: compat_base_tree_version: No such file or directory
cat: compat_version: No such file or directory
cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory

compat-wireless code metrics

    786829 - Total upstream lines of code being pulled
      2093 - backport code changes
      1831 - backport code additions
       262 - backport code deletions
      7292 - backport from compat module
      9385 - total backport code
    1.1928 - % of code consists of backport work
