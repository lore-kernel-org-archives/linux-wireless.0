Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37774 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbeHBUsg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 16:48:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v2] qtnfmac: implement basic WoWLAN support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180802104043.32068-1-sergey.matyukevich.os@quantenna.com>
References: <20180802104043.32068-1-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Message-Id: <20180802185612.D0CF56063A@smtp.codeaurora.org> (sfid-20180802_205615_682755_817AD0E6)
Date: Thu,  2 Aug 2018 18:56:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> This patch implements basic WoWLAN support in qtnfmac driver, including
> processing of WoWLAN features reported by firmware and implementation
> of cfg80211 suspend/resume/wakeup callbacks. Currently the following
> WoWLAN triggers are supported: disconnect, magic packet,
> custom pattern packet.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

28b918848390 qtnfmac: implement basic WoWLAN support

-- 
https://patchwork.kernel.org/patch/10553471/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
