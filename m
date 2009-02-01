Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4563 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZBAAoH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 19:44:07 -0500
Date: Sat, 31 Jan 2009 19:43:49 -0500
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 4/5] ath5k: Update initvals
Message-ID: <20090201004349.GB17607@hash.localnet> (sfid-20090201_014413_254798_477C8AE4)
References: <20090131023007.GD3342@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090131023007.GD3342@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 31, 2009 at 04:30:07AM +0200, Nick Kossifidis wrote:
>  * Update initvals to match legacy and Sam's HAL
> 
>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

I spot checked some of these, this is the only thing I saw:

> -	{ AR5K_BEACON_CNT_5211, 0x00000000 },	/* change */
> +	{ AR5K_FRAME_CTL_QOSM, 	0x000fc78f },

legacy-hal and Sam disagree on the top 12 bits (0xffffc78f vs
0x000fc78f), we have Sam's.

Rest looks good to me, feel free to add my Acked-by if you want.
-- 
Bob Copeland %% www.bobcopeland.com

