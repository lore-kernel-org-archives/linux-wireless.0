Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57385 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760572AbcBYKCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 05:02:14 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] rtlwifi: Prepare for reworking 5G channels
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1455209592-12882-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20160225100214.1F023603D8@smtp.codeaurora.org> (sfid-20160225_110228_454516_474CEA62)
Date: Thu, 25 Feb 2016 10:02:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> There are 3 drivers in this family that have 5G radios. Each of them
> defines local copies of the available channels. This patch adds the
> two arrays to the core driver.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, 4 patches applied to wireless-drivers-next.git:

9696a159c398 rtlwifi: Prepare for reworking 5G channels
bb6fa826ba30 rtlwifi: rtl8192de: Convert driver to use common 5G channels
2784b00aa316 rtlwifi: rtl8192ee: Convert driver to use new 5G channel tables
0a44b22009d5 rtlwifi: rtl8821ae: Convert driver to use common 5G channel table

Kalle Valo
