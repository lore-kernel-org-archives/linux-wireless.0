Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48461 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbbFOKtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 06:49:24 -0400
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <21886.43539.833126.629494@gargle.gargle.HOWL> (sfid-20150615_124940_118070_C16D236E)
Date: Mon, 15 Jun 2015 16:03:55 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	nbd@openwrt.org
Subject: Re: [RFC] ath9k: advertise p2p dev support when chanctx
In-Reply-To: <1433913034-17801-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1433913034-17801-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic wrote:
> Add p2p dev support when ath9k loaded with
> use_chanctx=1. This will fix problem, when first
> interface is an AP and next we would like to run
> p2p_find. Before p2p scan failed.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
> @Felix, Sujith please review. I am not sure if didn't miss some
> case for NL80211_IFTYPE_P2P_DEVICE (special handling required?).

At least the callbacks for adding/removing interfaces need
to be handled ?

But, can you describe the sequence of commands used that
resulted in this issue ?

Sujith
