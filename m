Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2363 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab1ABSYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jan 2011 13:24:01 -0500
Date: Sun, 2 Jan 2011 13:23:59 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	nbd@openwrt.org, sedat.dilek@googlemail.com
Subject: Re: [ath5k-devel] [PATCH 1/6] ath5k: Always write tx powertable on
	hw
Message-ID: <20110102182359.GA31173@hash.localnet>
References: <20101203040300.GA2988@makis.mantri> <AANLkTinD+XrkXeUR2PNqj4eVVvTmrh8a9c4UEy0Nr7JE@mail.gmail.com> <201101012351.07339.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201101012351.07339.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 01, 2011 at 11:51:07PM +0900, Bruno Randolf wrote:
> > Reverting just this patch helps, so my power table must be broken
> > at start up.
> > 
> > I saw that Bruno had a later series that touched this area, so I'll
> > try them next.
> 
> Yep, they should fix that problem. Please try them and report if they don't.

Indeed, applied first 3 patches and problem is resolved (and now I see
you pointed it out in patch 3).  Thanks!

-- 
Bob Copeland %% www.bobcopeland.com

