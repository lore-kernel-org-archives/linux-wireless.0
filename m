Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34259 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbcGSSR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 14:17:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rtlwifi: don't add include path for rtl8188ee
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160719153403.2967812-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-kernel@vger.kernel.org
Message-Id: <20160719181759.1AEB860239@smtp.codeaurora.org> (sfid-20160719_201804_276620_528C3829)
Date: Tue, 19 Jul 2016 18:17:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:
> For rtl8188ee, we pass -Idrivers/net/wireless/rtlwifi/ to gcc,
> however that directy no longer exists, so evidently this option
> is no longer required here and can be removed to avoid a warning
> when building with 'make W=1' or 'gcc -Wmissing-include-dirs'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, 1 patch applied to wireless-drivers-next.git:

944c07a7aac9 rtlwifi: don't add include path for rtl8188ee

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9237723/

