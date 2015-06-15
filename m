Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50529 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbbFOJbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 05:31:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: fix tm_trigger usage
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433675956-5787-1-git-send-email-ulli.kroll@googlemail.com>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>
Message-Id: <20150615093119.2F8431407E7@smtp.codeaurora.org> (sfid-20150615_113125_328708_CA29A176)
Date: Mon, 15 Jun 2015 09:31:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> While working on getting my rtl8821au driver in pretty shape for
> inclusion, it is dicosvered that the tm_trigger flag is used only for
> the first device using this driver.
> This flag handles the thermal power management in the hardware.
> 
> To change this add a entry in sttruct rtl_dm, so each device can handle
> is separately.
> 
> Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
