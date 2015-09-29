Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34870 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbbI2Hfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:35:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: net/wireless/wl18xx: Add missing MODULE_FIRMWARE
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1441238202.13198.5.camel@infradead.org>
To: Geoff Levand <geoff@infradead.org>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Dev@lists.96boards.org
Message-Id: <20150929073542.CD7E0140C0D@smtp.codeaurora.org> (sfid-20150929_093545_899259_E8E4BCA1)
Date: Tue, 29 Sep 2015 07:35:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Fixes the output of 'modinfo --field firmware'.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
