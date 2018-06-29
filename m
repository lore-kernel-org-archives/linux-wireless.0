Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935441AbeF2LqG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 07:46:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4/4] ath9k: use timespec64 for tsf_ts
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180618151142.1214422-4-arnd@arndb.de>
References: <20180618151142.1214422-4-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>,
        Russell Hu <rhu@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20180629114606.3325F60B10@smtp.codeaurora.org> (sfid-20180629_134632_761815_5F10D7BF)
Date: Fri, 29 Jun 2018 11:46:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> ath9k is the last remaining user of the deprecated getrawmonotonic()
> interface. There is nothing wrong with this usage, but migrating
> to a timespec64 based interface lets us clean up the old API.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

fe041deba4f6 ath9k: use timespec64 for tsf_ts

-- 
https://patchwork.kernel.org/patch/10471987/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
