Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42855 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbbCCNgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 08:36:31 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] ath9k: add per-vif TX power capability
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1424164338-10547-2-git-send-email-lorenzo.bianconi83@gmail.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de
Message-Id: <20150303133630.B74E9140BE2@smtp.codeaurora.org> (sfid-20150303_143634_649522_D254FC53)
Date: Tue,  3 Mar 2015 13:36:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Configure the HW with highest TX power among all vif when HW TPC has been
> enabled in order to add support to per-vif TX power capability. Use lowest
> configured power among all interfaces when TPC is disabled
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

283dd11994cd ath9k: add per-vif TX power capability
97bf861572ad ath9k: add per-vif TX power capability to TX path

Kalle Valo
