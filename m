Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63846 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1HOCWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 22:22:55 -0400
From: "Thiagarajan, Vasanthakumar" <vthiagar@qca.qualcomm.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 1/4] ath6kl: Release ar->lock right afer updating
 net_stats in ath6kl_rx()
Date: Mon, 15 Aug 2011 02:22:49 +0000
Message-ID: <EDA962D9696870498097087E0373E771084B8E@nasanexd01e.na.qualcomm.com> (sfid-20110815_042259_594439_F3FFB623)
References: <1313321916-29685-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1313321916-29685-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Thiagarajan, Vasanthakumar
Sent: Sunday, August 14, 2011 5:08 PM
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] ath6kl: Release ar->lock right afer updating net_stats in ath6kl_rx()

This lock is intended to protect stats there, not neccessary to
hold it beyond that.

John,

These patches are meant for ath6kl.git, sorry to address to you, i'll fix my --to next time.

Vasanth
