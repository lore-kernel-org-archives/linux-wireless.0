Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50541 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaFNN0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:26:41 -0400
Received: by mail-lb0-f172.google.com with SMTP id c11so2138531lbj.31
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:26:40 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: wireless: rtlwifi: rtl8188ee: reg.h:  Cleaning up if statement that always evaluates to false 
Date: Sat, 14 Jun 2014 15:27:37 +0200
Message-Id: <1402752458-13836-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140614_152719_574098_90D6B2EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found a logical error in an if statement that always evaluates to false.

This has after same discussion resulted in that we add a macro to handle this.

This was partly found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  net: wireless: rtlwifi: rtl8188ee: reg.h:  Cleaning up if statement that always evaluates to false

 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h |    1 +
 1 file changed, 1 insertion(+)

-- 
1.7.10.4

