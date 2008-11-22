Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2184 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbYKVAxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 19:53:55 -0500
Date: Fri, 21 Nov 2008 19:52:40 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: ipw3945-devel@lists.sourceforge.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	wally@theblackmoor.net
Subject: Re: Unusually low speeds with ath5k and iwl3945
Message-ID: <20081122005240.GA27826@hash.localnet> (sfid-20081122_015400_590004_79931552)
References: <492719ED.5000006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <492719ED.5000006@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 21, 2008 at 10:28:29PM +0200, Maxim Levitsky wrote:
> I initially blamed iwl3945, then thought it got fixed, but now I have 
> ath5k, and speeds are low
> and I suspect that both drivers has bugs regarding to speed.

Quite possible, but both use mac80211 for rate control.  Which rate 
control algorithm are you using?  

-- 
Bob Copeland %% www.bobcopeland.com

