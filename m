Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49322 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933954AbdCVJER (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 05:04:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] zd1211rw: fix NULL-deref at probe
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170313124421.28587-2-johan@kernel.org>
References: <20170313124421.28587-2-johan@kernel.org>
To: Johan Hovold <johan@kernel.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Message-Id: <20170322090415.BE414609FF@smtp.codeaurora.org> (sfid-20170322_100422_670443_E9981171)
Date: Wed, 22 Mar 2017 09:04:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johan Hovold <johan@kernel.org> wrote:
> Make sure to check the number of endpoints to avoid dereferencing a
> NULL-pointer or accessing memory beyond the endpoint array should a
> malicious device lack the expected endpoints.
> 
> Fixes: a1030e92c150 ("[PATCH] zd1211rw: Convert installer CDROM device into WLAN device")
> Cc: Daniel Drake <dsd@gentoo.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

ca260ece6a57 zd1211rw: fix NULL-deref at probe

-- 
https://patchwork.kernel.org/patch/9620721/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
