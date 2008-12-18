Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10315 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYLRDdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 22:33:05 -0500
Subject: effort to merge iwl3945 into iwlagn
From: Zhu Yi <yi.zhu@intel.com>
To: "John W.Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 18 Dec 2008 11:32:13 +0800
Message-Id: <1229571133.24353.21.camel@debian.sh.intel.com> (sfid-20081218_043309_614357_DF4C6E65)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

You may probably know we plan to merge the iwl3945 driver into iwlagn.
So we will have a single iwlagn driver supporting 3945/4965/5000/later
devices. This removes the duplication between iwl3945 and iwlagn and
should be easier to maintain in the future.

We started the merge last week and we have now queued some patches in
our GIT (branch iwl3945, patches are between upstream..iwl3945):
http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=shortlog;h=iwl3945
All of them are code movement and no functional change.

As the .29 merge window will be closed soon and it's the holiday season,
we plan to get this done (iwl3945 will be completely removed) by .30
kernel. What do you think we should do for these patches now? Do you
want to merge them into wireless-test master or create an own branch for
it? It might bring you some burden for managing them in
wireless-testing. But we really want to avoid the patch bomb when we
submit the final patchset altogether for .30.

Thanks,
-yi

