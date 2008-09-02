Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47415 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbYIBVPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 17:15:30 -0400
Date: Tue, 2 Sep 2008 17:05:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/11] iwlwifi driver fixes for 2.6.27
Message-ID: <20080902210542.GF3050@tuxdriver.com> (sfid-20080902_231534_379885_2543540E)
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2008 at 05:24:59PM +0800, Zhu Yi wrote:
> Hi,
> 
> Here are the iwlwifi patches vital for 2.6.27. Please apply.
> 
> Thanks,
> -yi
> 
> [PATCH 01/11] iwlwifi: W/A for the TSF correction in IBSS
> [PATCH 02/11] iwlwifi: use mac80211 band and channel settings
> [PATCH 03/11] iwlwifi: fix hidden ssid discovery in passive channels
> [PATCH 04/11] iwlwifi: remove false rxon if rx chain changes
> [PATCH 05/11] iwlwifi: workaround interrupt handling no some platforms
> [PATCH 06/11] iwlwifi: fix apm_stop
> [PATCH 07/11] iwlwifi: generic init calibrations framework
> [PATCH 08/11] iwlwifi: call apm stop on exit
> [PATCH 09/11] iwlwifi: fix station mimo power save values
> [PATCH 10/11] iwlwifi: fix rx_chain computation
> [PATCH 11/11] iwlwifi: fix 64bit platform firmware loading

Thanks to Marcel for going through this stack of patches and
reinforcing the point about offering better changelogs and about
giving more careful consideration to differentiating fixes from
features/cleanups/etc.

FWIW, I think that "regressions only" is a bit too strict for a hard
rule.  Also, I think that many of these patches are still mergeable
for 2.6.27 if we are given more thorough explanations of the actual
problems they are meant to address and the actual solutions they
apply to those problems.

I hope you will resubmit this series (more or less) with more thorough
changelogs in the near future.

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
