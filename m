Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56155
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbYIKXET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 19:04:19 -0400
Date: Thu, 11 Sep 2008 16:04:12 -0700 (PDT)
Message-Id: <20080911.160412.204624680.davem@davemloft.net> (sfid-20080912_010424_007532_4B76426E)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-09-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080911203205.GK3423@tuxdriver.com>
References: <20080911203205.GK3423@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 11 Sep 2008 16:32:05 -0400

> The latest round of patches intended for 2.6.28.  Johannes has returned,
> so there is of course a ton of mac80211 stuff (mostly cleanups, etc).  :-)
> 
> Please let me know if there are problems!

Pulled and pushed back out to net-next-2.6, thanks John.  I'll
deal with the merge conflict you mentioned next.

Wireless is accumulating lots more warnings during the build for
me, please look into this.

Thanks again.

drivers/net/wireless/orinoco.c: In function 'orinoco_ioctl_get_encodeext':
drivers/net/wireless/orinoco.c:4780: warning: comparison of distinct pointer types lacks a cast
drivers/net/wireless/orinoco.c: In function 'orinoco_translate_ext_scan':
drivers/net/wireless/orinoco.c:5691: warning: format '%016llx' expects type 'long long unsigned int', but argument 4 has type 'long unsigned int'
drivers/net/wireless/orinoco.c:5691: warning: format '%016llx' expects type 'long long unsigned int', but argument 4 has type 'long unsigned int'
drivers/net/wireless/b43/phy_g.c: In function 'b43_gphy_op_recalc_txpower':
drivers/net/wireless/b43/phy_g.c:3191: warning: unused variable 'dbm'
drivers/net/wireless/iwlwifi/iwl-scan.c:92: warning: 'iwl_escape_essid' defined but not used
drivers/net/wireless/libertas/cmd.c: In function 'lbs_set_channel':
drivers/net/wireless/libertas/cmd.c:861: warning: unused variable 'old_channel'
drivers/net/wireless/libertas_tf/if_usb.c: In function '__if_usb_submit_rx_urb':
drivers/net/wireless/libertas_tf/if_usb.c:334: warning: cast to pointer from integer of different size
