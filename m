Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19350 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753949AbcIIMJh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 08:09:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath9k: use ieee80211_tx_status_noskb where possible
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160804214940.78476-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>
Message-ID: <7af2860bf42c4600aa0669cd2d7e0c53@euamsexm01a.eu.qualcomm.com> (sfid-20160909_140940_332400_8EDEE214)
Date: Fri, 9 Sep 2016 14:09:27 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> It removes the need for undoing the padding changes to skb->data and it
> improves performance by eliminating one tx status lookup per MPDU in the
> status path. It is also useful for preparing a follow-up fix to better
> handle powersave filtering.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Thanks, 2 patches applied to ath-next branch of ath.git:

d94a461d7a7d ath9k: use ieee80211_tx_status_noskb where possible
315c457ff123 ath9k: improve powersave filter handling

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9264385/
