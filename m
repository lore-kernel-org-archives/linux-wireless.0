Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4004 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab0BGPFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 10:05:01 -0500
Date: Sun, 7 Feb 2010 10:04:15 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 04/10] ath5k: remove get_tx_stats() mac80211 op
Message-ID: <20100207150415.GA9085@hash.localnet>
References: <20100207082044.31474.48583.stgit@tikku> <20100207082107.31474.55453.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100207082107.31474.55453.stgit@tikku>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 07, 2010 at 10:21:07AM +0200, Kalle Valo wrote:
> get_tx_stats() will be removed from mac80211.
> 
> Compile-tested only.

The ath5k portion is equivalent to the rfc I posted a while ago
(http://patchwork.kernel.org/patch/37537/ - didn't check the rest) so you
happily have my:

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

