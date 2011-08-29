Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab1H2MU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:20:56 -0400
Date: Mon, 29 Aug 2011 14:20:15 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iwlegacy: change IWL_WARN to IWL_DEBUG_HT in
 iwl4965_tx_agg_start
Message-ID: <20110829122013.GA3597@redhat.com> (sfid-20110829_142104_383663_4B86401A)
References: <1314537977-20097-1-git-send-email-Gregory.Dietsche@cuw.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1314537977-20097-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 28, 2011 at 08:26:16AM -0500, Greg Dietsche wrote:
> This message should be a debug message and not a warning. So
> change it from IWL_WARN to IWL_DEBUG_HT.

I'm currently doing massive iwlegacy driver cleanup. Would be easier
for me to apply these patches on top of my changes instead of rebase
my patches. I will queue these two patches and post them together with
my pending patches.

Thanks
Stanislaw  
