Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40363 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbJNLQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:16:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] ath9k: rename ini_modes_rxgain_5g_xlna to
 ini_modes_rxgain_xlna
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1443504277-3482-1-git-send-email-miaoqing@codeaurora.org>
To: miaoqing pan <miaoqing@codeaurora.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, kvalo@qca.qualcomm.com,
	Miaoqing Pan <miaoqing@codeaurora.org>
Message-Id: <20151014111628.5763C141C88@smtp.codeaurora.org> (sfid-20151014_131631_586996_148B8036)
Date: Wed, 14 Oct 2015 11:16:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> rename the variable as preparation for using the array with 2.4 GHz
> band, etc.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Thanks, 2 patches applied to wireless-drivers-next.git:

871d0051f060 ath9k: rename ini_modes_rxgain_5g_xlna to ini_modes_rxgain_xlna
cfa2b42b4d9a ath9k: fix QCA9561 XLNA rxgain initial

Kalle Valo
