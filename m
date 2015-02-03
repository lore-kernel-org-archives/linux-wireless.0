Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:62982 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965676AbbBCRP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 12:15:26 -0500
Received: by mail-ob0-f170.google.com with SMTP id va2so11714853obc.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 09:15:25 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH RESEND 0/2] Resend critical patches for rtl8192ee
Date: Tue,  3 Feb 2015 11:15:16 -0600
Message-Id: <1422983718-21432-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150203_181531_786653_F3CAA0BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle,

These are the two patches that would not apply to wireless-drivers-next.
They have been rebased, and are generated against a pull done today.

Thanks,

Larry
---

Larry Finger (1):
  rtlwifi: rtl8192ee: Fix problems with calculating free space in FIFO

Troy Tan (1):
  rtlwifi: rtl8192ee: Fix handling of new style descriptors

 drivers/net/wireless/rtlwifi/pci.c           | 31 +++++++++++++++------
 drivers/net/wireless/rtlwifi/pci.h           |  7 +++++
 drivers/net/wireless/rtlwifi/rtl8192ee/sw.c  |  3 +--
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c | 40 +++++++++++++++++-----------
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.h |  1 +
 drivers/net/wireless/rtlwifi/wifi.h          |  1 +
 6 files changed, 57 insertions(+), 26 deletions(-)

-- 
2.1.4

