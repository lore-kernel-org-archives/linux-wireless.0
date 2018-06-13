Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:42751 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935261AbeFMMK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 08:10:29 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tamizh chelvam <tamizhr@codeaurora.org>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Add support to configure and monitor txrate threshold
In-Reply-To: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
Date: Wed, 13 Jun 2018 14:10:26 +0200
Message-ID: <87fu1q7uq5.fsf@toke.dk> (sfid-20180613_141034_444741_EA4BBDB0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tamizh chelvam <tamizhr@codeaurora.org> writes:

> This patchsets introduced new NL command and api to support
> configuring txrate threshold for the connected stations and api to
> notify userspace application upon crossing the configured txrate threshold.
> This will be useful for the application which requires
> station's current capability change information.

What is the intended use case? Asking mostly out of curiosity :)

-Toke
