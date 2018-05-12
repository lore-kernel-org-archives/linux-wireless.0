Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbeELIxv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 04:53:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v5] wireless-drivers: Dynamically allocate struct station_info
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <152595697934.5071.3080928108635708657.stgit@alrua-kau>
References: <152595697934.5071.3080928108635708657.stgit@alrua-kau>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180512085350.D7C7C6022C@smtp.codeaurora.org> (sfid-20180512_105355_186063_124302DC)
Date: Sat, 12 May 2018 08:53:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen wrote:

> Since the addition of the TXQ stats to cfg80211, the station_info struct
> has grown to be quite large, which results in warnings when allocated on
> the stack. Fix the affected places to do dynamic allocations instead.
> 
> Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>

Patch applied to wireless-drivers-next.git, thanks.

41bd3d585da2 wireless-drivers: Dynamically allocate struct station_info

-- 
https://patchwork.kernel.org/patch/10391797/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
