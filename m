Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35406 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbbJWKol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 06:44:41 -0400
Received: by wicll6 with SMTP id ll6so25517372wic.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 03:44:40 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: staging/rtl8723au should be removed
To: driverdev-devel@linuxdriverproject.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
Message-ID: <562A0F94.1010001@gmail.com> (sfid-20151023_124444_365743_AD10F01E)
Date: Fri, 23 Oct 2015 12:44:36 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Support for RTL8723AU devices was added to
wireless-drivers-next.git recently: https://marc.info/?l=linux-wireless&m=144541406318463
commit: https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h?id=26f1fad29ad973b0fb26a9ca3dcb2a73dde781aa
