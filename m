Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36120 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964787AbbEOVdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 17:33:12 -0400
Received: by obbkp3 with SMTP id kp3so87442247obb.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2015 14:33:11 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/5] rtlwifi: Update some regulatory information
Date: Fri, 15 May 2015 16:32:58 -0500
Message-Id: <1431725583-7324-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150515_233322_099068_0D0D37F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent tests using Chrome Autotest has shown some errors in the regulatory
information used in these drivers.

These patches should be sent to NEXT. They fix real bugs, but they are not
that important.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Shao Fu (5):
  rtlwifi: Update regulatory database
  rtlwifi: rtl8188ee: Apply the new regulatory information
  rtlwifi: rtl8192ee: Apply the regulatory changes to driver
  rtlwifi: rtl8723be: Update driver for regulatory changes
  rtlwifi: rtl8821ae: Fix problem with regulatory information

 drivers/net/wireless/rtlwifi/regd.c         | 42 ++++++++++++++++++++++++++---
 drivers/net/wireless/rtlwifi/regd.h         |  1 +
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c |  4 +--
 drivers/net/wireless/rtlwifi/rtl8192ee/hw.c |  4 +--
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c |  4 +--
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c |  4 +--
 6 files changed, 47 insertions(+), 12 deletions(-)

-- 
2.1.4

