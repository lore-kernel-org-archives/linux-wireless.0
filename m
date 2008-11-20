Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11977 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYKTGOm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 01:14:42 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 22:14:42 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>, <zenczykowski@gmail.com>,
	<Bennyam.Malavazi@atheros.com>
Subject: [RFC 0/2] ath9k: Few DMA fixups
Date: Wed, 19 Nov 2008 22:14:38 -0800
Message-ID: <1227161680-23229-1-git-send-email-lrodriguez@atheros.com> (sfid-20081120_071449_939267_023C8196)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch series corrects our usage of DMA inconsistantly.
I'm pretty certain about the RX and patch #2, do need one glance
over the fixups in beacon.c though. I also haven't had time to test
these though so hence RFC. Better to post ASAP though.

  Luis
