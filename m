Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39102 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbbL3PHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 10:07:30 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/8] rtlwifi: rtl8723be: Fix module parameter initialization
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Message-Id: <20151230150729.E4CC66026F@smtp.codeaurora.org> (sfid-20151230_160734_793969_7FB87800)
Date: Wed, 30 Dec 2015 15:07:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This driver has a number of errors in the module initialization. These
> include the following:
> 
> Parameter msi_support is stored in two places - one is removed.
> Paramters sw_crypto and disable_watchdog were never stored in the final
> locations, nor were they initialized properly.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Thanks, 8 patches applied to wireless-drivers-next.git:

7079604ddb83 rtlwifi: rtl8723be: Fix module parameter initialization
793b09994211 rtlwifi: rtl8723ae: Fix initialization of module parameters
78bae1de422a rtlwifi: rtl8821ae: Fix errors in parameter initialization
06f34572c611 rtlwifi: rtl8188ee: Fix module parameter initialization
d4d60b4caaa5 rtlwifi: rtl8192de: Fix incorrect module parameter descriptions
7503efbd82c1 rtlwifi: rtl8192se: Fix module parameter initialization
b24f19f16b9e rtlwifi: rtl8192ce: Fix handling of module parameters
b68d0ae7e586 rtlwifi: rtl8192cu: Add missing parameter setup

Kalle Valo
