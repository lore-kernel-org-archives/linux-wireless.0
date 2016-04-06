Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33052 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbcDFShG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 14:37:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/9] rtlwifi: Fix Smatch warnings
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1458240064-31422-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20160406183704.4FF01611CD@smtp.codeaurora.org> (sfid-20160406_203712_011330_28A37805)
Date: Wed,  6 Apr 2016 18:37:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Smatch reports the following:
> 
>   CHECK   drivers/net/wireless/realtek/rtlwifi/pci.c
> drivers/net/wireless/realtek/rtlwifi/pci.c:366 rtl_pci_check_buddy_priv() error: we previously assumed 'tpriv' could be null (see line 368)
> drivers/net/wireless/realtek/rtlwifi/pci.c:1216 _rtl_pci_init_struct() warn: inconsistent indenting
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, 9 patches applied to wireless-drivers-next.git:

37c52934c668 rtlwifi: Fix Smatch warnings
2e074fab347e rtlwifi: btcoexist: Fix Smatch warning
844026f609fc rtlwifi: rtl8188ee: Fix Smatch warnings
de8a9a6eeb57 rtlwifi: rtl8192c-common: Fix Smatch warning
05d9e1bba43b rtlwifi: rtl8192ee: Fix Smatch warning
c42ceccec170 rtlwifi: rtl8192se: Fix Smatch warning
154fb486df3d rtlwifi: rtl8723ae: Fix Smatch warning
b3c4201bce5e rtlwifi: rtl8723be: Fix Smatch warnings
1e812458206e rtlwifi: rtl8821ae: Fix Smatch warnings

Kalle Valo
