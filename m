Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42654 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYLROpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 09:45:12 -0500
Date: Thu, 18 Dec 2008 09:30:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: effort to merge iwl3945 into iwlagn
Message-ID: <20081218143030.GB4121@tuxdriver.com> (sfid-20081218_154527_248293_22E8B6DD)
References: <1229571133.24353.21.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229571133.24353.21.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 18, 2008 at 11:32:13AM +0800, Zhu Yi wrote:

> You may probably know we plan to merge the iwl3945 driver into iwlagn.
> So we will have a single iwlagn driver supporting 3945/4965/5000/later
> devices. This removes the duplication between iwl3945 and iwlagn and
> should be easier to maintain in the future.
> 
> We started the merge last week and we have now queued some patches in
> our GIT (branch iwl3945, patches are between upstream..iwl3945):
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=shortlog;h=iwl3945
> All of them are code movement and no functional change.
> 
> As the .29 merge window will be closed soon and it's the holiday season,
> we plan to get this done (iwl3945 will be completely removed) by .30
> kernel. What do you think we should do for these patches now? Do you
> want to merge them into wireless-test master or create an own branch for
> it? It might bring you some burden for managing them in
> wireless-testing. But we really want to avoid the patch bomb when we
> submit the final patchset altogether for .30.

I can keep them in wireless-testing until after the 2.6.29 merge
window closes.  Go ahead and send them.

Thanks!

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
