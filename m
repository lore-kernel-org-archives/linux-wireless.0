Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753203AbeF0QK4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 12:10:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/4] zd1211rw: stop using deprecated get_seconds()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180618151142.1214422-2-arnd@arndb.de>
References: <20180618151142.1214422-2-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180627161056.0916760B16@smtp.codeaurora.org> (sfid-20180627_181113_784354_B8FBB125)
Date: Wed, 27 Jun 2018 16:10:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> The get_seconds() function is deprecated because of the y2038 overflow.
> In zd1211rw we don't even care about the absolute value, so this is
> not a problem, but it's equally trivial to change to the non-deprecated
> ktime_get_seconds().
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

2 patches applied to wireless-drivers-next.git, thanks.

71e140b57151 zd1211rw: stop using deprecated get_seconds()
3cade2f3d98a ipw2x00: track time using boottime

-- 
https://patchwork.kernel.org/patch/10471961/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
