Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab2DHTMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 15:12:52 -0400
Received: by iagz16 with SMTP id z16so5092406iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2012 12:12:50 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] Patches for rtl8192de to fix cut version constants and recognition
Date: Sun,  8 Apr 2012 14:12:32 -0500
Message-Id: <1333912354-16983-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120408_211339_631377_3DFED1B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

V2 - clean up the patches
V3 - fix "From" address

Forest Bond (2):
  rtl8192de: Clean up and fix 92D cut version constants and macros.
  rtl8192de: Recognize 92D E-CUT version.

 drivers/net/wireless/rtlwifi/rtl8192de/def.h |   16 +++++++---------
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |    6 +++++-
 2 files changed, 12 insertions(+), 10 deletions(-)

-- 
1.7.10

