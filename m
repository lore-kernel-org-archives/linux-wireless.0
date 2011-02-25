Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37629 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab1BYWNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 17:13:17 -0500
Date: Fri, 25 Feb 2011 17:05:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] iwlegacy: change some symbols duplicated from iwlwifi
 directory
Message-ID: <20110225220504.GI15897@tuxdriver.com>
References: <1298670606-1250-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298670606-1250-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry about the SPAM -- either I had some network issues here or I
_really_ meant for you to see this!! :-)

On Fri, Feb 25, 2011 at 04:50:06PM -0500, John W. Linville wrote:
> drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x29f0): multiple definition of `iwl_rates'
> drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0xa68): first defined here
> powerpc64-linux-ld: Warning: size of symbol `iwl_rates' changed from 143 in drivers/net/wireless/iwlwifi/built-in.o to 130 in drivers/net/wireless/iwlegacy/built-in.o
> drivers/net/wireless/iwlegacy/built-in.o:(.data+0x0): multiple definition of `bt_coex_active'
> drivers/net/wireless/iwlwifi/built-in.o:(.data+0x668): first defined here
> drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x750): multiple definition of `iwl_eeprom_band_1'
> drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0x27d0): first defined here
> drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x3f0): multiple definition of `iwl_bcast_addr'
> drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0x24f8): first defined here
> drivers/net/wireless/iwlegacy/built-in.o:(.bss+0x3d48): multiple definition of `iwl_debug_level'
> drivers/net/wireless/iwlwifi/built-in.o:(.bss+0x21950): first defined here
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
