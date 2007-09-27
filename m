Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2223 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbXI0VIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 17:08:10 -0400
Date: Thu, 27 Sep 2007 16:41:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi driver updates
Message-ID: <20070927204144.GE7991@tuxdriver.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <11908636643693-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 27, 2007 at 11:27:29AM +0800, Zhu Yi wrote:
> Here are some updates for iwlwifi against davem's net-2.6.24 GIT.
> 
> [PATCH] iwlwifi: replacing IPW with IWL in error messages
> [PATCH] iwlwifi: workaournd REPLY_COMPRESSED_BA command in iwl_rx_handle
> [PATCH] iwlwifi: Correction for sending beacon in config_ap
> [PATCH] iwlwifi: clear station table in rxon unconditionally
> [PATCH] iwlwifi: Fix typo in rate sacling algorithm
> [PATCH] iwlwifi: fix add_station to avoid FW error
> [PATCH] iwlwifi: removing unnecessary memset in 4965 rate scale
> [PATCH] iwlwifi: add debugfs framework to rate scale
> [PATCH] iwlwifi: add read rate scale table debugfs function
> [PATCH] iwlwifi: limit printouts on hot path
> [PATCH] iwlwifi: add supp_rates to rate scale sta private data
> [PATCH] iwlwifi: rs_rate_scale_perform clean up
> [PATCH] iwlwifi: set fixed rate through debugfs
> [PATCH] iwlwifi: add debugfs rate scale stats
> [PATCH] iwlwifi: Update iwlwifi version stamp to 1.1.17

I'll accept that patches -- thanks for sending an update so
(relatively) quickly since the upstream push!

In the future, please try to be a bit more descriptive in your
changelog entries.  Several of them seemed to be either obvious
(and thereby perhaps unnecessary) or they described the patch itself
rather than the motivation for the change.  Describing the why is
more important than the what in most cases. :-)

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
