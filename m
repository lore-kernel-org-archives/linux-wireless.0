Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40324 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbJNLPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:15:35 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [RFC] rtlwifi: rtl8192cu: Add missing case in rtl92cu_get_hw_reg
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1442296916-24336-1-git-send-email-plaes@plaes.org>
To: Priit Laes <plaes@plaes.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Taehee Yoo <ap420073@gmail.com>,
	linux-wireless@vger.kernel.org, Priit Laes <plaes@plaes.org>
Message-Id: <20151014111534.58A5C141C96@smtp.codeaurora.org> (sfid-20151014_131537_448426_47B4EEF1)
Date: Wed, 14 Oct 2015 11:15:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Driver was reporting 'switch case not processed' after association,
> so HW_VAR_KEEP_ALIVE was added and filled similarily to other drivers.
> 
> Positive side effect to this seems to be a bit more stable connection.
> 
> Signed-off-by: Priit Laes <plaes@plaes.org>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
