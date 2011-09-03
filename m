Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64452 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1ICS6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 14:58:42 -0400
Received: by gxk21 with SMTP id 21so2767595gxk.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Sep 2011 11:58:41 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: drop Copyright for not really copyrightable info
Date: Sat,  3 Sep 2011 21:01:01 +0200
Message-Id: <1315076463-11222-2-git-send-email-zajec5@gmail.com> (sfid-20110903_205845_592592_58545D6B)
In-Reply-To: <1315076463-11222-1-git-send-email-zajec5@gmail.com>
References: <1315076463-11222-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As discussed in "Licensing wlc_phy_radio.h and brcm80211" (Message-ID:
<AANLkTinQMRGkOvi4e4JMsHGV_BF_4Rf5oHCtZgQjwQ1g@mail.gmail.com>) content
of that file is not copyrightable, just names and numbers.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/radio_2056.h |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/b43/radio_2056.h b/drivers/net/wireless/b43/radio_2056.h
index d52df6b..a7159d8 100644
--- a/drivers/net/wireless/b43/radio_2056.h
+++ b/drivers/net/wireless/b43/radio_2056.h
@@ -1,29 +1,3 @@
-/*
-
-  Broadcom B43 wireless driver
-
-  Copyright (c) 2010 Rafał Miłecki <zajec5@gmail.com>
-
-  Some parts of the code in this file are derived from the brcm80211
-  driver  Copyright (c) 2010 Broadcom Corporation
-
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; see the file COPYING.  If not, write to
-  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
-  Boston, MA 02110-1301, USA.
-
-*/
-
 #ifndef B43_RADIO_2056_H_
 #define B43_RADIO_2056_H_
 
-- 
1.7.3.4

