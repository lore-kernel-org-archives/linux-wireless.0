Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:52899 "HELO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758486Ab2DJDHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 23:07:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/5] mwifiex: fix typo in RSSI_HIGH event handling
Date: Mon,  9 Apr 2012 20:06:53 -0700
Message-Id: <1334027217-23724-2-git-send-email-bzhao@marvell.com> (sfid-20120410_050727_469704_080525B5)
In-Reply-To: <1334027217-23724-1-git-send-email-bzhao@marvell.com>
References: <1334027217-23724-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a copy-n-paste error introduced in recent patch
"mwifiex: add set_cqm_rssi_config handler support".

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index e90c34d..1f71105 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -988,7 +988,7 @@ mwifiex_cmd_802_11_subsc_evt(struct mwifiex_private *priv,
 		rssi_tlv->abs_value = subsc_evt_cfg->bcn_h_rssi_cfg.abs_value;
 		rssi_tlv->evt_freq = subsc_evt_cfg->bcn_h_rssi_cfg.evt_freq;
 
-		dev_dbg(priv->adapter->dev, "Cfg Beacon Low Rssi event, "
+		dev_dbg(priv->adapter->dev, "Cfg Beacon High Rssi event, "
 			"RSSI:-%d dBm, Freq:%d\n",
 			subsc_evt_cfg->bcn_h_rssi_cfg.abs_value,
 			subsc_evt_cfg->bcn_h_rssi_cfg.evt_freq);
-- 
1.7.0.2

