Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43138 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3J1GVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 02:21:00 -0400
Received: by mail-ee0-f46.google.com with SMTP id c1so3156104eek.5
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 23:20:59 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: memory leak fixes
Date: Mon, 28 Oct 2013 07:18:12 +0100
Message-Id: <1382941094-3291-1-git-send-email-michal.kazior@tieto.com> (sfid-20131028_072109_633031_F518B9F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior (2):
  ath10k: plug memory leak in wmi mgmt tx worker
  ath10k: plug memory leak on beacon tx

 drivers/net/wireless/ath/ath10k/mac.c |  4 +++-
 drivers/net/wireless/ath/ath10k/wmi.c | 11 +++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

-- 
1.8.4.rc3

