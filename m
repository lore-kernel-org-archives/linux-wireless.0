Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:35843 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbaAWKnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 05:43:42 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so331917ead.27
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 02:43:41 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: add CSA support
Date: Thu, 23 Jan 2014 11:38:24 +0100
Message-Id: <1390473506-15677-1-git-send-email-michal.kazior@tieto.com> (sfid-20140123_114408_818039_C85211F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a refactored and rewritten AP CSA patch
split into 2. As a bonus this fixes STA CSA as
well.


Michal Kazior (2):
  ath10k: implement channel switching
  ath10k: implement AP CSA

 drivers/net/wireless/ath/ath10k/core.h |  12 ++-
 drivers/net/wireless/ath/ath10k/mac.c  | 182 ++++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.c  |  11 ++
 3 files changed, 175 insertions(+), 30 deletions(-)

-- 
1.8.5.3

