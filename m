Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17560 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2HNBFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 21:05:19 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20521.41830.874571.640990@gargle.gargle.HOWL> (sfid-20120814_030556_458516_CFB03741)
Date: Tue, 14 Aug 2012 06:31:26 +0530
To: Antonio Quartulli <ordex@autistici.org>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k_htc: implement sta_rc_update() mac80211 callback
In-Reply-To: <1344793001-27085-1-git-send-email-ordex@autistici.org>
References: <1344793001-27085-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli wrote:
> In case of changes in the supported rates set for a given station, it is now
> possible to use this callback to update the current internal state of the
> station in the htc driver.

The driver changes are okay, there are now multiple calls to update_rate()
inside ath9k_htc, but we can clean that later.

Sujith
