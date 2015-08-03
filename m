Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42244 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbHCI04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 04:26:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [-4.2] rtlwifi: rtl8723be: Add module parameter for MSI interrupts
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438539853-29619-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Message-Id: <20150803082655.DBE83140035@smtp.codeaurora.org> (sfid-20150803_102705_850669_C98A857F)
Date: Mon,  3 Aug 2015 08:26:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The driver code allows for the disabling of MSI interrupts; however the
> module_parm line was missed and the option fails to show with modinfo.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> [3.15+]

Thanks, applied to wireless-drivers.git.

Kalle Valo
