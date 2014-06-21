Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60991 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaFUVCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 17:02:43 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so2327519wiv.15
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jun 2014 14:02:42 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	Peter Wu <lekensteyn@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: wireless: rtlwifi: rtl8192de: hw.c:  Cleaning up if statement that always evaluates to false 
Date: Sat, 21 Jun 2014 23:03:41 +0200
Message-Id: <1403384623-9737-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140621_230246_389690_12E01AFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found a logical error in an if statement that always evaluates to false.

This has after same discussion resulted in that we add a macro to handle this.

This was partly found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  net: wireless: rtlwifi: rtl8192de: hw.c:  Cleaning up if statement that always evaluates to false

 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.10.4

