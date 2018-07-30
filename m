Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbeG3Psy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 11:48:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 6/6] qtnfmac: implement basic WoWLAN support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180531091102.28666-7-sergey.matyukevich.os@quantenna.com>
References: <20180531091102.28666-7-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Message-Id: <20180730141342.B613A61D77@smtp.codeaurora.org> (sfid-20180730_161345_236858_ECF9F68B)
Date: Mon, 30 Jul 2018 14:13:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> This patch implements core WoWLAN support in qtnfmac driver, including
> processing of WoWLAN features reported by firmware and implementation
> of cfg80211 suspend/resume/wakeup callbacks. Currently the following
> WoWLAN triggers are supported: disconnect, magic packet,
> custom pattern packet.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Doesn't apply anymore as I dropped patch 5

fatal: sha1 information is lacking or useless (drivers/net/wireless/quantenna/qtnfmac/cfg80211.c).
error: could not build fake ancestor
Applying: qtnfmac: implement basic WoWLAN support
Patch failed at 0001 qtnfmac: implement basic WoWLAN support
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10440567/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
