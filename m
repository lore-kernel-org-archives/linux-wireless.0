Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53676 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371AbbAHLSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 06:18:35 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so2540419wiv.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 03:18:34 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: add wmi-tlv debug event handling
Date: Thu,  8 Jan 2015 12:18:15 +0100
Message-Id: <1420715897-18706-1-git-send-email-michal.kazior@tieto.com> (sfid-20150108_121839_279458_D6DFB8B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New wmi-tlv firmware will deliver debug messages
via new events.

Note: This may yield some (trivial) conflicts
against my beacon/presp template patchset.


Michal Kazior (2):
  ath10k: implement diag data container event
  ath10k: implement diag event

 drivers/net/wireless/ath/ath10k/trace.h   |  68 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 102 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  19 ++++++
 3 files changed, 189 insertions(+)

-- 
1.8.5.3

