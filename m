Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43971
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761562AbYB2Vz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 16:55:29 -0500
Date: Fri, 29 Feb 2008 13:55:29 -0800 (PST)
Message-Id: <20080229.135529.193701021.davem@davemloft.net> (sfid-20080229_215535_960823_7CE8038D)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6.26 2008-02-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080229212218.GG3234@tuxdriver.com>
References: <20080229212218.GG3234@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 29 Feb 2008 16:22:18 -0500

> Here is a ton of wireless patches intended for 2.6.26 -- too much to go
> into details.
> 
> Let me know if there are problems!

Pulled and pushed back out to net-2.6.26, thanks.

Please fix the following build warnings:

drivers/net/wireless/ath5k/debug.c: In function 'read_file_tsf':
drivers/net/wireless/ath5k/debug.c:203: warning: format '%016llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
drivers/net/wireless/ath5k/debug.c:203: warning: format '%016llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
drivers/net/wireless/ath5k/debug.c: In function 'read_file_beacon':
drivers/net/wireless/ath5k/debug.c:274: warning: format '%016llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
drivers/net/wireless/ath5k/debug.c:274: warning: format '%016llx' expects type 'long long unsigned int', but argument 4 has type 'u64'

drivers/net/wireless/iwlwifi/iwl-4965.c: In function 'iwl4965_tx_status_reply_compressed_ba':
drivers/net/wireless/iwlwifi/iwl-4965.c:3907: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
drivers/net/wireless/iwlwifi/iwl-4965.c: In function 'iwl4965_rx_reply_compressed_ba':
drivers/net/wireless/iwlwifi/iwl-4965.c:4039: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type '__le64'
drivers/net/wireless/iwlwifi/iwl-4965.c:4046: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
drivers/net/wireless/iwlwifi/iwl4965-base.c: In function 'iwl4965_tx_status_reply_tx':
drivers/net/wireless/iwlwifi/iwl4965-base.c:3661: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'u64'
