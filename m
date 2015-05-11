Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33061 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbEKLlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 07:41:09 -0400
Date: Mon, 11 May 2015 12:41:04 +0100
From: Okash Khawaja <okash.khawaja@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] adm8211 patches
Message-ID: <20150511114104.GA4985@bytefire-computer> (sfid-20150511_134114_880225_54E06382)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches include two changes:

1. Code cleanup around a switch-case statement
2. Bug fix for the possible PCI cache line sizes

Okash Khawaja (2):
  adm8211: fix checkpatch errors for indentation and new line.
  adm8211: fixed the possible pci cache line sizes inside switch-case

 drivers/net/wireless/adm8211.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

-- 
2.4.0

