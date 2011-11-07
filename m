Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3649 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1KGVPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 16:15:22 -0500
Message-ID: <4EB84A51.7060208@qca.qualcomm.com> (sfid-20111107_221526_309203_F0B033F3)
Date: Mon, 7 Nov 2011 23:14:57 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix tx packet drop in AP mode with bridge
References: <1320401931-3493-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1320401931-3493-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2011 12:18 PM, Vasanthakumar Thiagarajan wrote:
> skb is dropped in ath6kl_data_tx() when the headroom in skb
> is insufficient. We hit this condition for every skb in AP mode
> which is used with bridge, so all tx packets are getting dropped
> when tried to send traffic to wireless client from bridge. Fix
> this by reallocating the headroom instead of dropping the skb
> when it has lesser headroom than needed.

Thanks, applied.

Kalle
