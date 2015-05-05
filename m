Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38025 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbbEEWju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 18:39:50 -0400
Date: Tue, 5 May 2015 23:39:40 +0100
From: Okash Khawaja <okash.khawaja@gmail.com>
To: joe@perches.com
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] adm8211 patches
Message-ID: <20150505223940.GA3546@bytefire-computer> (sfid-20150506_004011_268385_354B7B17)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches include two changes:

1. Code cleanup around a switch-case statement
2. Bug fix for the possible PCI cache line sizes

Okash Khawaja (2):
  adm8211: fix checkpatch errors for indentation and new line
  adm8211: fix the possible pci cache line sizes inside switch-case

 drivers/net/wireless/adm8211.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

-- 
1.9.1

