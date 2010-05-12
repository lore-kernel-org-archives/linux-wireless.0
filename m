Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:26044 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754114Ab0ELI1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 04:27:41 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0282042860
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 17:27:40 +0900 (JST)
Subject: [PATCH 1/3] iw: add channel command name
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Wed, 12 May 2010 17:27:41 +0900
Message-ID: <20100512082741.26746.78569.stgit@tt-desk>
In-Reply-To: <20100512082516.26746.19520.stgit@tt-desk>
References: <20100512082516.26746.19520.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 util.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/util.c b/util.c
index 42c992d..0c6d978 100644
--- a/util.c
+++ b/util.c
@@ -165,6 +165,7 @@ static const char *commands[NL80211_CMD_MAX + 1] = {
 	[NL80211_CMD_SET_TX_BITRATE_MASK] = "set_tx_bitrate_mask",
 	[NL80211_CMD_REGISTER_ACTION] = "register_action",
 	[NL80211_CMD_ACTION] = "action",
+	[NL80211_CMD_SET_CHANNEL] = "set_channel",
 };
 
 static char cmdbuf[100];

