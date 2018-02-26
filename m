Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55502 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753805AbeBZOwn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 09:52:43 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Make ath10k report discarded packets to mac80211
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <863ed21f-d2fe-f1e1-6f3c-b4061c777f59@aoifes.com>
References: <863ed21f-d2fe-f1e1-6f3c-b4061c777f59@aoifes.com>
To: =?utf-8?q?Ignacio_N=C3=BA=C3=B1ez_Hernanz?=
        <nacho.nunez@aoifes.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Ignacio_N=c3=ba=c3=b1ez_Hernanz?=
        <nacho.nunez@aoifes.com>
Message-Id: <20180226145242.E22C560848@smtp.codeaurora.org> (sfid-20180226_155247_384542_62C51D2D)
Date: Mon, 26 Feb 2018 14:52:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ignacio Núñez Hernanz wrote:

> Whenever ath10k firmware discards a packet (HTT_TX_COMPL_STATE_DISCARD
> flag), the skb is freed and mac80211 does not get feedback through
> ieee80211_tx_status().
> 
> Instead, make sure that the IEEE80211_TX_STAT_ACK flag is disabled and
> let the packet go through, like ath9k does.
> 
> Signed-off-by: Ignacio Nunez Hernanz <nacho.nunez@aoifes.com>
> [kvalo@codeaurora.org: rebase patch manually]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

abb374fe8460 ath10k: make ath10k report discarded packets to mac80211

-- 
https://patchwork.kernel.org/patch/9859221/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
