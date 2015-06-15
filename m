Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50622 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbbFOJcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 05:32:02 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [V2, 1/3] rtlwifi: rtl8192cu: remove duplicated routine
 in_rtl92c_phy_rf6052_config_parafile
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433588234-27248-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150615093201.4872214080C@smtp.codeaurora.org> (sfid-20150615_113205_858288_408FE990)
Date: Mon, 15 Jun 2015 09:32:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> in the _rtl92c_phy_rf6052_config_parafile(), cases
> RF90_PATH_A and RF90_PATH_B call the same routine.
> so i remove one of these routine. also the return
> routine is duplicated. so i remove it.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

138055e23b66 rtlwifi: rtl8192cu: remove duplicated routine in _rtl92c_phy_rf6052_config_parafile
8657f9c4d52f rtlwifi: rtl8192cu: debug message change "RTL8192CE" to "RTL8192CU"
d92460097c00 rtlwifi: rtl8192cu: Fix variable isfirst_ampdu

Kalle Valo
