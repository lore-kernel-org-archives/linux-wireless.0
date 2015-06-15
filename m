Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50280 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbbFOJ3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 05:29:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/3] rtlwifi: rtl8192cu: remove IS_HARDWARE_TYPE_8192CE
 andIS_HARDWARE_TYPE_8192CU
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433407416-752-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150615092939.EB49E140794@smtp.codeaurora.org> (sfid-20150615_112944_279284_DFD6E987)
Date: Mon, 15 Jun 2015 09:29:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> in the rtlwifi/rtl8192cu, IS_HARDWARE_TYPE_8192CE and IS_HARDWARE_TYPE_8192CU
> is unnecessary. because rtlwifi/rtl8192cu codes aren't shared.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

f5372e940cdb rtlwifi: rtl8192cu: remove IS_HARDWARE_TYPE_8192CE and IS_HARDWARE_TYPE_8192CU
1d6b2fb1bc80 rtlwifi: rtl8192cu: remove _InitBeaconParameters().
fbcaee1c6da1 rtlwifi: rtl8192cu: remove INTF_PCI and INTF_USB

Kalle Valo
