Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34155 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbbB0IF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 03:05:58 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: Modify some USB de-initialize code.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423586430-12454-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150227080557.D1FA913FA09@smtp.codeaurora.org> (sfid-20150227_090604_132633_9FCD0680)
Date: Fri, 27 Feb 2015 08:05:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Delete SET_USB_STOP macro and rtl_usb_deinit because
> those are called twice in USB de-initialize routine.
> Add some de-initialize workqueue function in USB disconnect routine.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
