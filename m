Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 42.248.sfcn.org ([160.7.248.42]:52313 "HELO mail.mypals.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752387AbZEFDmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 23:42:37 -0400
From: Alf <alf@mypals.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k in 2.6.29.1 won't associate with AP
Date: Tue, 5 May 2009 21:42:38 -0600
Cc: Tulio Magno Quites Machado Filho <tuliom@quites.com.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200905021218.23747.alf@mypals.org> <20090504224952.GB9342@joutaro.lan> <b6c5339f0905042236o7ab21feai5aef015510428d02@mail.gmail.com>
In-Reply-To: <b6c5339f0905042236o7ab21feai5aef015510428d02@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905052142.38780.alf@mypals.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 May 2009 11:36:06 pm Bob Copeland wrote:
> Yes, 2413 should work -- also can you try latest
> wireless-testing tree?  It has a boatload of updates for
> ath5k.  If something there works then we can perhaps narrow
> it down a bit.

I tried it a few days ago and it still didn't work.  Even the latest 
snapshot from madwifi didn't work.  They only thing that has worked is 
ndiswrapper.

-- 
Alf
@
