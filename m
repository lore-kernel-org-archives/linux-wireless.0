Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39794 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbbDXKdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 06:33:32 -0400
Message-ID: <1429871610.1852.33.camel@sipsolutions.net> (sfid-20150424_123335_888518_B9489074)
Subject: Re: [PATCH] cfg80211: change GO_CONCURRENT to IR_CONCURRENT for STA
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 24 Apr 2015 12:33:30 +0200
In-Reply-To: <1427793259-18851-1-git-send-email-arik@wizery.com> (sfid-20150331_111424_391160_B1851455)
References: <1427793259-18851-1-git-send-email-arik@wizery.com>
	 (sfid-20150331_111424_391160_B1851455)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-31 at 12:14 +0300, Arik Nemtsov wrote:
> The GO_CONCURRENT regulatory definition can be extended to station
> interfaces requesting to IR as part of TDLS off-channel operations.
> Rename the GO_CONCURRENT flag to IR_CONCURRENT and allow the added
> use-case.
> 
> Change internal users of GO_CONCURRENT to use the new definition.
> 
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> ---
> This patch depends on "cfg80211: Allow GO concurrent relaxation after
> BSS disconnetion" which was recently sent by Emmanuel. It will also
> conflict with a different change to iwlwifi/iwl-nvm-parse.c that's currently
> in Kalle's tree ("iwlwifi: mvm: consider LAR support during NVM parse").
> But that's not too hard to fix.

Perhaps you should rebase it to not have that dependency since we're
still discussing that other patch.

johannes

