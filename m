Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbeEPL1c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 07:27:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sushant Kumar Mishra <sushant2k1513@gmail.com>
Cc: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: invoke software scan when hardware scan returns EPERM
References: <1526468599-14665-1-git-send-email-sushant2k1513@gmail.com>
Date: Wed, 16 May 2018 14:27:27 +0300
In-Reply-To: <1526468599-14665-1-git-send-email-sushant2k1513@gmail.com>
        (Sushant Kumar Mishra's message of "Wed, 16 May 2018 16:33:18 +0530")
Message-ID: <87lgcjkfhc.fsf@codeaurora.org> (sfid-20180516_132735_718547_E63F75E9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sushant Kumar Mishra <sushant2k1513@gmail.com> writes:

> From: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
>
> Currently, software scan in mac80211 is used by drivers, which don't
> implement hardware scan. However some drivers which have implemented
> hardware scan may also sometimes want to use software scan in mac80211.
> Such drivers can return '-EPERM' and ask mac80211 to fallback to
> software scan with this patch.
>
> Signed-off-by: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>

This and the following rsi patch should in the same patchset as there's
a dependency. This being patch 1 and "rsi: add support for hardware scan
offload" patch 2.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#sending_large_patches_or_multiple_patches

Also Johanne's address (Johannes@codeaurora.org, "Berg
<johannes"@sipsolutions.net) looked bogus so I fixed it.

-- 
Kalle Valo
