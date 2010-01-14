Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:56044 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab0ANLJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 06:09:29 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o0EB9Qf5008708
	for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 05:09:27 -0600
Received: from [127.0.1.1] (trdhcp21270.nmp.nokia.com [172.22.212.70])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o0EB98JT022314
	for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 13:09:11 +0200
Subject: [PATCH 0/2] mac80211: powersave documentation improvements
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 14 Jan 2010 13:09:00 +0200
Message-ID: <20100114110826.22608.23087.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

he are some improvements to the mac80211 powersave documentation. I
wanted to fix few warnings at the same.

---

Kalle Valo (2):
      mac80211: fix mac80211.h documentation warnings
      mac80211: improve powersave documentation


 Documentation/DocBook/mac80211.tmpl |    2 -
 include/net/mac80211.h              |   82 ++++++++++++++++++++++++++---------
 2 files changed, 61 insertions(+), 23 deletions(-)

