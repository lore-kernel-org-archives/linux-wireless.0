Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50700 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2JDCd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 22:33:28 -0400
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20588.62828.845432.706022@gargle.gargle.HOWL> (sfid-20121004_043332_151910_688D7F89)
Date: Thu, 4 Oct 2012 08:03:16 +0530
To: Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 3.7 2/3] ath9k: improve suspend/resume reliability
In-Reply-To: <1349291272-93080-2-git-send-email-nbd@openwrt.org>
References: <1349291272-93080-1-git-send-email-nbd@openwrt.org>
	<1349291272-93080-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Ensure that drv_start() always returns true, as a failing hw start usually
> eventually leads to crashes when there's still a station entry present.
> Call a power-on reset after a resume and after a hw reset failure to bring
> the hardware back to life again.

In what situations did HW reset (via start() or resume()) fail ?

Sujith
