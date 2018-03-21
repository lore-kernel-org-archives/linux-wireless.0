Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36118 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbeCULpi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 07:45:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] ath9k_htc: use non-QoS NDP for AP probing
References: <20180321100143.28080-1-johannes@sipsolutions.net>
Date: Wed, 21 Mar 2018 13:45:31 +0200
In-Reply-To: <20180321100143.28080-1-johannes@sipsolutions.net> (Johannes
        Berg's message of "Wed, 21 Mar 2018 11:01:43 +0100")
Message-ID: <87zi31tzxg.fsf@purkki.adurom.net> (sfid-20180321_124542_919959_174911FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> When switching mac80211 to use QoS NDP, it turned out that
> ath9k_htc is somehow broken by this, e.g. see
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=891060.
>
> Fix this by using the new mac80211 flag to go back to the
> old, incorrect, behaviour for this driver.
>
> Fixes: 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing")
> Reported-by: Ben Caradoc-Davies <ben@transient.nz>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
