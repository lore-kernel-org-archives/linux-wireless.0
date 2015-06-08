Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46380 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbbFHIs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 04:48:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8192cu: Fix performance issue.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433378862-2064-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150608084855.398741407D2@smtp.codeaurora.org> (sfid-20150608_104859_014316_3769CBFE)
Date: Mon,  8 Jun 2015 08:48:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> After physical reconnect, the rtl8192cu chipset shows low
> transmission rates.It cause is that variable "iqk_initialized"
> do not de-initialized. So I add this code.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
