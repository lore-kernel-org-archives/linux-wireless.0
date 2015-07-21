Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38066 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbbGUO7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 10:59:09 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8821ae: Fix an expression that is always false
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1436368730-636-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>,
	David Binderman <dcb314@hotmail.com>
Message-Id: <20150721145908.9F8EC141A64@smtp.codeaurora.org> (sfid-20150721_165938_823021_03706D75)
Date: Tue, 21 Jul 2015 14:59:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In routine _rtl8821ae_set_media_status(), an incorrect mask results in a test
> for AP status to always be false. Similar bugs were fixed in rtl8192cu and
> rtl8192de, but this instance was missed at that time.
> 
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> [3.18+]
> Cc: David Binderman <dcb314@hotmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
