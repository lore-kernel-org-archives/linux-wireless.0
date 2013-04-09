Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f51.google.com ([209.85.210.51]:62602 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab3DIFxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 01:53:05 -0400
Received: by mail-da0-f51.google.com with SMTP id g27so2911474dan.24
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 22:53:05 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: qca_vkondrat@qca.qualcomm.com, yunsenw@qca.qualcomm.com,
	kandala@qca.qualcomm.com, wireless-regdb@lists.infradead.org,
	green@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/3] wireless-regdb: a few regulatory updates
Date: Mon,  8 Apr 2013 22:52:55 -0700
Message-Id: <1365486778-2336-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130409_075310_439152_BE8B88ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

John, here's as few pending regulatory updates.

Luis R. Rodriguez (3):
  wireless-regdb: enable HT40 in RU - Russian Federation
  wireless-regdb: enable VHT80 when world roaming
  wireless-regdb: add VHT channels 1..3 to world regdom

 db.txt |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
1.7.10.4

