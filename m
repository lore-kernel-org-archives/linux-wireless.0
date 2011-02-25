Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51918 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab1BYWha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 17:37:30 -0500
Subject: Re: [PATCH] iwlegacy: change some symbols duplicated from iwlwifi
 directory
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20110225220504.GI15897@tuxdriver.com>
References: <1298670606-1250-1-git-send-email-linville@tuxdriver.com>
	 <20110225220504.GI15897@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 14:22:30 -0800
Message-ID: <1298672550.28351.113.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-25 at 14:05 -0800, John W. Linville wrote:
> Sorry about the SPAM -- either I had some network issues here or I
> _really_ meant for you to see this!! :-)
> 
> On Fri, Feb 25, 2011 at 04:50:06PM -0500, John W. Linville wrote:
> > drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x29f0): multiple definition of `iwl_rates'
> > drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0xa68): first defined here
> > powerpc64-linux-ld: Warning: size of symbol `iwl_rates' changed from 143 in drivers/net/wireless/iwlwifi/built-in.o to 130 in drivers/net/wireless/iwlegacy/built-in.o
> > drivers/net/wireless/iwlegacy/built-in.o:(.data+0x0): multiple definition of `bt_coex_active'
> > drivers/net/wireless/iwlwifi/built-in.o:(.data+0x668): first defined here
> > drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x750): multiple definition of `iwl_eeprom_band_1'
> > drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0x27d0): first defined here
> > drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x3f0): multiple definition of `iwl_bcast_addr'
> > drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0x24f8): first defined here
> > drivers/net/wireless/iwlegacy/built-in.o:(.bss+0x3d48): multiple definition of `iwl_debug_level'
> > drivers/net/wireless/iwlwifi/built-in.o:(.bss+0x21950): first defined here
> > 

Thank you very much for fix this, we just miss it :-(

Wey


