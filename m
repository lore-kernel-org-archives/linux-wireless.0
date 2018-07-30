Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58724 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbeG3PsH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 11:48:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 3/6] qtnfmac: implement cfg80211 power management callback
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180531091102.28666-4-sergey.matyukevich.os@quantenna.com>
References: <20180531091102.28666-4-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Message-Id: <20180730141255.A966161D77@smtp.codeaurora.org> (sfid-20180730_161258_689253_36A0E3EE)
Date: Mon, 30 Jul 2018 14:12:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> From: Sergei Maksimenko <smaksimenko@quantenna.com>
> 
> Implement set_power_mgmt() callback that forwards power saving
> settings to the device firmware.
> 
> Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>

2 patches applied to wireless-drivers-next.git, thanks.

4775ad06b56a qtnfmac: implement cfg80211 power management callback
8f1180e08ed4 qtnfmac: enable multiple SSIDs scan support

-- 
https://patchwork.kernel.org/patch/10440561/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
