Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1319 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYJZQbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 12:31:38 -0400
Date: Sun, 26 Oct 2008 12:31:25 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH] ath5k: Update interrupt masking code
Message-ID: <20081026163125.GA15292@hash.localnet> (sfid-20081026_173143_387684_A568A2EC)
References: <20081026031957.GA3090@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081026031957.GA3090@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 26, 2008 at 05:19:57AM +0200, Nick Kossifidis wrote:
> +	AR5K_INT_QCBRURN =	0x20000000, /* Non common */

Are you sure about the values? ar5212reg.h from legacy-hal has:

#define AR_ISR_QCBRURN                  0x04000000 /* QCU CBR underrun
interrupt */
[...]
#define AR_IMR_QCBRURN                  0x04000000 /* QCU CBR underrun
interrupt */

>  #define	AR5K_TXNOFRM_QCU	0x000ffc00
> +#define	AR5K_TXNOFRM_QCU_S	9

10? :)

-- 
Bob Copeland %% www.bobcopeland.com

