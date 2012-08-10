Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62239 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2HJQPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 12:15:48 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20517.13157.200980.747377@gargle.gargle.HOWL> (sfid-20120810_181552_403459_A0980A58)
Date: Fri, 10 Aug 2012 21:44:29 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: [PATCH 3.6 4/4] ath9k_hw: enable PA linearization
In-Reply-To: <1344344772-49459-4-git-send-email-nbd@openwrt.org>
References: <1344344772-49459-1-git-send-email-nbd@openwrt.org>
	<1344344772-49459-2-git-send-email-nbd@openwrt.org>
	<1344344772-49459-3-git-send-email-nbd@openwrt.org>
	<1344344772-49459-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> This feature had been disabled in ath9k because the code to support
> it was incomplete, but now the code is in sync with the internal QCA
> codebase, so it's time to enable it.
> 
> On many newer devices, the calibration is assumed to be done with PA
> linearization enabled.
> 
> Tests with a particular AR933x device showed that the signal emitted
> at full power was highly distorted and unreliable with PA linearization
> disabled. With this patch, the signal becomes clear and stability
> is improved.

PAPRD for AR9462 requires changes to the HW code, can you leave out
AR9462 until I come up with the necessary patches ?

Sujith
