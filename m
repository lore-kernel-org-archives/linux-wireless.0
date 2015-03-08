Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58609 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbbCHHmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 03:42:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	David Miller <davem@davemloft.net>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2015-03-07
References: <1425750475.20750.1.camel@egrumbacBox>
Date: Sun, 08 Mar 2015 09:42:40 +0200
In-Reply-To: <1425750475.20750.1.camel@egrumbacBox> (Emmanuel Grumbach's
	message of "Sat, 7 Mar 2015 17:47:55 +0000")
Message-ID: <87bnk4ylxr.fsf@kamboji.qca.qualcomm.com> (sfid-20150308_084345_515844_04A5CD8E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

can you pull this directly? I don't think there's any point for me to
pull this to my tree as I don't have anything else queued up for -next
at the moment. I can fast forward my tree once you have pulled this.

The tag is:

https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
tags/iwlwifi-next-for-kalle-2015-03-07

Emmanuel, thanks for the quick fix.

Kalle

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> This is the fix for the unfortunate compilation problem I caused in
> iwlwifi-next.
>
> Please pull.
>
> The following changes since commit
> 190f1029757346b72f297729cf8e5c562f2e9d8c:
>
>   iwlwifi: mvm: don't override passive dwell in case of fragmented scan
> (2015-03-02 08:20:32 +0200)
>
> are available in the git repository at:
>
>
> https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> tags/iwlwifi-next-for-kalle-2015-03-07
>
> for you to fetch changes up to aa5e18320788728476e84e2140aa736bc5525c87:
>
>   iwlwifi: mvm: fix compilation with IWLWIFI_DEBUGFS not set (2015-03-07
> 19:40:02 +0200)
>
> ----------------------------------------------------------------
> fix compilation when DEBUGFS isn't set
>
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: mvm: fix compilation with IWLWIFI_DEBUGFS not set
>
>  drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 1 -
>  drivers/net/wireless/iwlwifi/mvm/mac80211.c    | 2 ++
>  drivers/net/wireless/iwlwifi/mvm/mvm.h         | 2 +-
>  drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c    | 2 ++
>  4 files changed, 5 insertions(+), 2 deletions(-)
>

-- 
Kalle Valo
