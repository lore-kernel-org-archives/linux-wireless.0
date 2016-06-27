Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38889 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbcF0TMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 15:12:50 -0400
Date: Mon, 27 Jun 2016 22:12:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: net: wireless: add brcm80211 drivers
Message-ID: <20160627191243.GQ32247@mwanda> (sfid-20160627_211254_806168_2A69B12E)
References: <20160627132221.GA1114@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160627132221.GA1114@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were a some others as well:

drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:26511 wlc_phy_rxcal_radio_setup_nphy() warn: mask and shift to zero
drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:26585 wlc_phy_rxcal_radio_setup_nphy() warn: mask and shift to zero
drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:26635 wlc_phy_rxcal_radio_setup_nphy() warn: mask and shift to zero

regards,
dan carpenter

