Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:47387 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab3GaIzW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 04:55:22 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] ath10k: fixes
Date: Wed, 31 Jul 2013 10:55:10 +0200
Message-ID: <1375260915-22500-1-git-send-email-michal.kazior@tieto.com> (sfid-20130731_105526_612654_4E233B96)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a batch up of a few fixes for ath10k
driver I had in my queue for some time now.


Michal Kazior (5):
  ath10k: prevent using invalid ringbuffer indexes
  ath10k: make sure to use passive scan when n_ssids is 0
  ath10k: advertise more conservative intf combinations
  ath10k: zero arvif memory on add_interface()
  ath10k: fix failpath in MSI-X setup

 drivers/net/wireless/ath/ath10k/ce.c  |    5 +++++
 drivers/net/wireless/ath/ath10k/mac.c |   16 +++++++++++++---
 drivers/net/wireless/ath/ath10k/pci.c |    7 ++++++-
 3 files changed, 24 insertions(+), 4 deletions(-)

-- 
1.7.9.5

