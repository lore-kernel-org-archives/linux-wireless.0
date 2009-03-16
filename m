Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1049 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbZCPC7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 22:59:45 -0400
Date: Sun, 15 Mar 2009 22:28:21 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 1/3] ath5k: Choose the right initvals for RF2425
Message-ID: <20090316022821.GA14792@hash.localnet> (sfid-20090316_035949_965608_7CF28984)
References: <20090315201339.GA5246@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090315201339.GA5246@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 15, 2009 at 10:13:39PM +0200, Nick Kossifidis wrote:
>  * Fix a typo in initvals.c so that we use the RF2425 array for RF2425 and not RF2413
> 
>  Note: This also fixes incorect pd gain overlap since RF2425 has different pd gain overlap from RF2413
> 
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Nice work, series:

Acked-by: Bob Copeland <me@bobcopeland.com>

If you do a follow-up cleanup patch, one quick thought I had is that
ee_pwr_cal_[abg] could be an array indexed by mode which might save a 
few switch statements - I didn't look at it that hard though.

-- 
Bob Copeland %% www.bobcopeland.com

