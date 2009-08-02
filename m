Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1135 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbZHBQPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 12:15:39 -0400
Date: Sun, 2 Aug 2009 12:14:46 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, nbd@openwrt.org
Subject: Re: [ath5k-devel] [PATCH 4/4] ath5k: Use SWI to trigger calibration
Message-ID: <20090802161446.GB25339@hash.localnet>
References: <20090731181020.GE7963@makis> <43e72e890907311115h56df6ac0p1ea7165e305a10ee@mail.gmail.com> <40f31dec0907311125o1654bd23jee861ba8bea57611@mail.gmail.com> <b6c5339f0907311211w4d810b23uc6ec8027924da647@mail.gmail.com> <40f31dec0907311252n76adfde7kb9f34bf8c6baf34c@mail.gmail.com> <20090801132253.GB15971@hash.localnet> <40f31dec0908010631x84ddfcap99a871f3513cf22b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0908010631x84ddfcap99a871f3513cf22b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 01, 2009 at 04:31:27PM +0300, Nick Kossifidis wrote:
> I thought about calling ath5k_hw_stop_rx_pcu but i don't think it's
> necessary i mean it won't receive anyway, why mess with pcu ?

Yeah, agreed, we can just ignore rx.

-- 
Bob Copeland %% www.bobcopeland.com

