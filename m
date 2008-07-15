Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34026
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753659AbYGODpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 23:45:32 -0400
Date: Mon, 14 Jul 2008 20:45:32 -0700 (PDT)
Message-Id: <20080714.204532.116542087.davem@davemloft.net> (sfid-20080715_054536_698254_D32C0605)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-07-14
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080714192302.GA2541@tuxdriver.com>
References: <20080714192302.GA2541@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 14 Jul 2008 15:23:02 -0400

> Here is one last(?) round of miscellaneous patches I hope to get into
> 2.6.27.  There are mostly driver updates, including a sizable iwlwifi
> set of changes.
> 
> Please let me know if there are problems!

Pulled into net-next-2.6, thanks John.

If someone could fix the following wireless warnings I'd appreciate
it.

Thanks!

drivers/net/wireless/rt2x00/rt2x00mac.c: In function 'rt2x00mac_conf_tx':
drivers/net/wireless/rt2x00/rt2x00mac.c:557: warning: comparison is always true due to limited range of data type
drivers/net/wireless/b43/main.c: In function 'b43_qos_params_upload':
drivers/net/wireless/b43/main.c:3085: warning: comparison is always false due to limited range of data type
drivers/net/wireless/b43/main.c:3090: warning: comparison is always false due to limited range of data type
drivers/net/wireless/b43/main.c:3095: warning: comparison is always false due to limited range of data type
drivers/net/wireless/b43/main.c:3100: warning: comparison is always false due to limited range of data type
drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_get_blink_rate':
drivers/net/wireless/iwlwifi/iwl-led.c:271: warning: format '%lld' expects type 'long long int', but argument 6 has type 's64'
drivers/net/wireless/iwlwifi/iwl-led.c:271: warning: format '%lld' expects type 'long long int', but argument 7 has type 'u64'
