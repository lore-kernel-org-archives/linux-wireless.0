Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34249 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2AQMJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 07:09:16 -0500
Received: by yhoo21 with SMTP id o21so33558yho.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 04:09:16 -0800 (PST)
From: ilanelias78@gmail.com
To: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v3 0/3] NFC: Download TI NFC init script
Date: Tue, 17 Jan 2012 14:11:30 +0200
Message-Id: <1326802293-11539-1-git-send-email-ilane@ti.com> (sfid-20120117_130919_708645_D70348C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

v2: added endian annotations (Thanks Johannes).
v3: split the patch into a set of 3 patches (Thanks Samuel).

Ilan Elias (3):
  NFC: Add endian annotations to nfcwilink driver
  NFC: Download TI NFC init script
  NFC: Free sk_buff if nfcwilink_send fails

 drivers/nfc/nfcwilink.c |  305 +++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 294 insertions(+), 11 deletions(-)

