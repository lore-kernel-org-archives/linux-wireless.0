Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55558 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdH3QQn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 12:16:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 00/27] qtnfmac: allow to configure channel, BW, HT/VHT caps
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
Date: Wed, 30 Aug 2017 19:16:38 +0300
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com> (igor
        mitsyanko os's message of "Thu, 24 Aug 2017 19:29:57 -0700")
Message-ID: <87ziahni8p.fsf@purkki.adurom.net> (sfid-20170830_181646_358871_767B3302)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

igor.mitsyanko.os@quantenna.com writes:

> This patchset has a goal to make operational parameters (channel, BW,
> HT/VHT capabilities) configuration possible for qtnfmac driver.
> Basically the idea is to make driver level as thin as possible, and let
> everything to be handled by userspace/nl80211 and wireless device itself.

This patchset is just too big and pain to review. Preferably no more
than 10-12 patches per set, please. If the patches bigger then the limit
should be even lower.

-- 
Kalle Valo
