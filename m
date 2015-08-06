Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51439 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbbHFHM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 03:12:57 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/3] ath9k: add fast-xmit support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1437563174-94761-1-git-send-email-nbd@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150806071257.7140E141FB2@smtp.codeaurora.org> (sfid-20150806_091300_021268_464B11BE)
Date: Thu,  6 Aug 2015 07:12:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, 3 patches applied to wireless-drivers-next.git:

f419c5f1d8d2 ath9k: add fast-xmit support
592fa228f213 ath9k: remove struct ath_atx_ac
d70d848a75fd ath9k: remove the sched field in struct ath_atx_tid

Kalle Valo
