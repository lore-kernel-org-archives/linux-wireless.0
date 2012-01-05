Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sfca-50.vyatta.com ([76.74.103.50]:38167 "EHLO fiji.vyatta.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab2AEStf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 13:49:35 -0500
Message-Id: <20120105184000.461663809@vyatta.com> (sfid-20120105_194939_962725_269A72F5)
Date: Thu, 05 Jan 2012 10:39:49 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] brcmf: make net_device_ops const
References: <20120105183947.295358582@vyatta.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c	2012-01-05 09:50:35.768590224 -0800
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c	2012-01-05 10:02:57.488495190 -0800
@@ -1123,7 +1123,7 @@ int brcmf_bus_start(struct brcmf_pub *dr
 	return 0;
 }
 
-static struct net_device_ops brcmf_netdev_ops_pri = {
+static const struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_open = brcmf_netdev_open,
 	.ndo_stop = brcmf_netdev_stop,
 	.ndo_get_stats = brcmf_netdev_get_stats,


