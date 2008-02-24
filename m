Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:59900 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbYBXUVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 15:21:25 -0500
Date: Sun, 24 Feb 2008 15:21:12 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Message-ID: <20080224202112.GA4545@hash.localnet> (sfid-20080224_202131_536223_7DFB24D7)
References: <20080224042851.GE4426@makis.domain.invalid> <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com> <20080224175933.GA4360@hash.localnet> <40f31dec0802241058h5b37a471s5092dd370a4f2a48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0802241058h5b37a471s5092dd370a4f2a48@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 24, 2008 at 08:58:09PM +0200, Nick Kossifidis wrote:
> Thanx, just plz put a new line here ->
> 
> +	/* Get MAC, PHY and RADIO revisions */
> +	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
> +
> +	/* Identify PCI-E cards */

> Acked-by: Nick Kossifidis <mickflemm@gmail.com>

Do you want me to respin and post the patch with the newline, or
are you just going to roll it into your changes?  I don't mind
either way, but if you pick it up, feel free to add my:

Tested-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com 

