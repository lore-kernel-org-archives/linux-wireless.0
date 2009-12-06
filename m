Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:35422 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933926AbZLFRUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 12:20:21 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: linville@tuxdriver.com
Subject: [PATCH 0/4] Setting coverage class (and ACK timeout and slot time)
Date: Sun, 6 Dec 2009 18:20:26 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200912061820.26320.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches implement a feature essential for long distance wireless links: 
setting ACK timeout and slot time. The API is based on a parameter called 
Coverage Class specified by the 802.11 standard.

The first two patches add support to the kernel 802.11 stack via a new nl80211 
parameter and a mac80211 callback.

Following two patches implement the callback in ath5k driver. Implementation 
in ath9k driver is planned.

One additional patch outside the series adds the necessary userspace support 
to iw.

Lukas Turek
