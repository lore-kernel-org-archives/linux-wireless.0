Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38910 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbbIZRfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2015 13:35:09 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [4.3] ath9k: declare required extra tx headroom
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1443106786-67564-1-git-send-email-nbd@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150926173508.CAB2413FCAB@smtp.codeaurora.org> (sfid-20150926_193514_224208_40D9C036)
Date: Sat, 26 Sep 2015 17:35:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> ath9k inserts padding between the 802.11 header and the data area (to
> align it). Since it didn't declare this extra required headroom, this
> led to some nasty issues like randomly dropped packets in some setups.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied to wireless-drivers.git.

Kalle Valo
