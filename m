Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38021 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbbKSPXg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 10:23:36 -0500
Subject: Re: [PATCH] ath5k: fix RTS/CTS by using proper rate flags
To: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
References: <1447945488-13665-1-git-send-email-me@bobcopeland.com>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <564DE926.9030001@openwrt.org> (sfid-20151119_162523_807892_D9B8BF93)
Date: Thu, 19 Nov 2015 16:22:14 +0100
MIME-Version: 1.0
In-Reply-To: <1447945488-13665-1-git-send-email-me@bobcopeland.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-11-19 16:04, Bob Copeland wrote:
> The rates in the tx control rateset do not have the protection
> flags applied, so RTS/CTS would never get enabled if requested.
> 
> Fix by using the rate flags in the rates returned by
> ieee80211_get_tx_rates().
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>
