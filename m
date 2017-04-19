Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27931 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934619AbdDSOBc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 10:01:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: Add cast to u8 to FREQ2FBIN macro
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170406212135.72157-1-mka@chromium.org>
References: <20170406212135.72157-1-mka@chromium.org>
To: Matthias Kaehlcke <mka@chromium.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        ath9k Development <ath9k-devel@qca.qualcomm.com>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, Grant Grundler <grundler@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Message-ID: <cc9e31d8452d4d24a24d56467b8b409c@euamsexm01a.eu.qualcomm.com> (sfid-20170419_160211_340092_45C55939)
Date: Wed, 19 Apr 2017 16:01:22 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias Kaehlcke <mka@chromium.org> wrote:
> The macro results are assigned to u8 variables/fields. Adding the cast
> fixes plenty of clang warnings about "implicit conversion from 'int' to
> 'u8'".
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Patch applied to ath-next branch of ath.git, thanks.

627871b71c89 ath9k: Add cast to u8 to FREQ2FBIN macro

-- 
https://patchwork.kernel.org/patch/9668479/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
