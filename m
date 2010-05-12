Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:37224 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754114Ab0ELI1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 04:27:36 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0439732854
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 17:27:34 +0900 (JST)
Subject: [PATCH 0/3] iw antenna command
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Wed, 12 May 2010 17:27:35 +0900
Message-ID: <20100512082516.26746.19520.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

here the iw part. the option parsing is more flexible now and i added a
possibility to use

  iw phy0 anenna set X

to set both RX and TX antennas

+ one small fix for the channel command name

bruno

---

Bruno Randolf (3):
      iw: add channel command name
      iw: sync nl80211.h with wireless-testing
      iw: Add antenna set/get


 Makefile  |    2 +
 antenna.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 nl80211.h |   12 ++++++++
 util.c    |    3 ++
 4 files changed, 104 insertions(+), 1 deletions(-)
 create mode 100644 antenna.c

-- 
Signature
