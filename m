Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35872 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2FSQyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 12:54:16 -0400
From: "Thiagarajan, Vasanthakumar" <vthiagar@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	"Manoharan, Sujith" <c_manoha@qca.qualcomm.com>,
	"Pitchaimani, Vadivel" <vadivel@qca.qualcomm.com>,
	"Hu, Russell" <rhu@qca.qualcomm.com>,
	"Yang, Aeolus" <aeolus@qca.qualcomm.com>,
	"Balasubramanian, Senthil Kumar" <senthilb@qca.qualcomm.com>
Subject: RE: [PATCH 01/10] ath9k_hw: Add register definitions for WoW support
Date: Tue, 19 Jun 2012 16:52:50 +0000
Message-ID: <EDA962D9696870498097087E0373E771CA93B1@aphydexd01b> (sfid-20120619_185419_670973_A31997E3)
References: <1340120850-9155-1-git-send-email-mohammed@qca.qualcomm.com>,<1340120850-9155-2-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1340120850-9155-2-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Shajakhan, Mohammed Shafi (Mohammed Shafi)
Sent: Tuesday, June 19, 2012 9:17 PM
To: John W. Linville
Cc: linux-wireless@vger.kernel.org; Rodriguez, Luis; ath9k-devel@lists.ath9k.org; Manoharan, Rajkumar; Manoharan, Sujith; Pitchaimani, Vadivel; Hu, Russell; Yang, Aeolus; Shajakhan, Mohammed Shafi (Mohammed Shafi); Balasubramanian, Senthil Kumar; Rodriguez, Luis
Subject: [PATCH 01/10] ath9k_hw: Add register definitions for WoW support

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

*MAC WoW registers

back-off shift, MAC interrupt enable, magic packet enable,
pattern match enable, aifs, slot wait period, keep alive
frame failure count, beacon fail enable, beacon timeout,
keep alive timeout, auto keep alive disable,
keep alive fail disable and their corresponding
status registers. keep alive frame delay,
pattern end/byte offsets, transmit buffers for
keep alive frames and storing the user patterns

*Power Management Control registers

pme_d3cold_vaux, host_pme_enable, aux_pwr_detect,
power_state_mask, wow_pme_clear

Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: vadivel@qca.qualcomm.com
Tested-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

You need not add Tested-by yourself, it is expected anyway.

Vasanth