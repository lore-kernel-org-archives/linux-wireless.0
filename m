Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37198 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752487AbdHGJGs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 05:06:48 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 00/10]  mac80211 patches from our internal tree 2017-08-05
References: <20170805084438.12550-1-luca@coelho.fi>
Date: Mon, 07 Aug 2017 12:06:43 +0300
In-Reply-To: <20170805084438.12550-1-luca@coelho.fi> (Luca Coelho's message of
        "Sat, 5 Aug 2017 11:44:28 +0300")
Message-ID: <87d187vja4.fsf@purkki.adurom.net> (sfid-20170807_110651_555614_9038A5F6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here are some pending mac80211 patches from our internal tree.
>
> The "mac80211: add api to start ba session timer expired flow" patch
> is needed by an iwlwifi patch that I want to send for -fixes, so it
> would have to be applied to -fixes as well.

We are getting to the later stages of the release cycle and I'm raising
the bar for wireless-drivers even higher. How serious iwlwifi bug is
that fixing?

> Should I send a separate patchset with these two so they can be both
> applied at the same time (either in the mac80211 or in
> wireless-drivers tree)?

Now that Johannes is away and I'm taking any urgent mac80211 patches, I
think the best approach is that you include mac80211 patch in the same
patchset as the iwlwifi patches destined for wireless-drivers.

-- 
Kalle Valo
