Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f194.google.com ([209.85.212.194]:33708 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbbJXWbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2015 18:31:47 -0400
From: Punit Vara <punitvara@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Punit Vara <punitvara@gmail.com>
Subject: [PATCH 0/3] Staging: wilc1000: Remove coccicheck warnings and error
Date: Sun, 25 Oct 2015 04:01:22 +0530
Message-Id: <1445725885-25995-1-git-send-email-punitvara@gmail.com> (sfid-20151025_003255_517775_83D23CED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Punit Vara (3):
  staging: wilc1000: Remove reference preceded by free
  Staging: wilc1000: Remove comparision of field address to NULL
  Staging: wilc1000: Remove boolean comparision

 drivers/staging/wilc1000/host_interface.c         | 4 ++--
 drivers/staging/wilc1000/linux_wlan.c             | 8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 7 +++----
 3 files changed, 9 insertions(+), 10 deletions(-)

-- 
2.5.3

