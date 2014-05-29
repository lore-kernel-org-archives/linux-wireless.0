Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58439 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaE2PkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 11:40:02 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Joe Perches <joe@perches.com>
Subject: Resubmitting [PATCH 4/7 v2]
Date: Thu, 29 May 2014 18:37:51 +0300
Message-ID: <1401377872-8562-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140529_174010_045041_C05359C0)
In-Reply-To: <1417278.VSQeiOskQO@lx-wigig-72>
References: <1417278.VSQeiOskQO@lx-wigig-72>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resubmitting patch with modification as suggested by Joe
(and some minor improvement).

John: patch ordes does not matter here, you can apply this after
my other patches.

Vladimir Kondratiev (1):
  wil6210: improve debug for WMI receive

 drivers/net/wireless/ath/wil6210/wmi.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

-- 
1.9.1

