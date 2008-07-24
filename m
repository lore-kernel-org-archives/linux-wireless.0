Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65379 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYGXVX2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 17:23:28 -0400
Subject: Re: [PATCH 1/12] ath5k: Update register list
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mick@madwifi.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
In-Reply-To: <20080720033041.GA7440@makis>
References: <20080720033041.GA7440@makis>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 17:23:25 -0400
Message-Id: <1216934605.3094.5.camel@dv> (sfid-20080724_232331_324857_093F44DD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-07-20 at 06:30 +0300, Nick Kossifidis wrote:
> * Update list of registers
>  * Use updated register macros inside hw.c and initvals.c

What happened to those patches?  Are they going to be applied?  Maybe
more cleanup is needed?

> -			ath5k_hw_reg_write(ah, 0x0002a002, AR5K_PHY(11));
> +			ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);

You are replacing macros with numbers in several places.  Maybe you
could introduce another macro?  Or is it the case when you had
interpretation of the registers, but now realize that it was wrong?

-- 
Regards,
Pavel Roskin
