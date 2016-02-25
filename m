Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35972 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbcBYAI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:08:57 -0500
Received: by mail-wm0-f45.google.com with SMTP id g62so5723782wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:08:56 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 0/7] mwifiex: cleanups 
Date: Thu, 25 Feb 2016 01:08:45 +0100
Message-Id: <1456358932-23114-1-git-send-email-afenkart@gmail.com> (sfid-20160225_010905_610887_F4F60980)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Fenkart (7):
  mwifiex: scan: simplify dereference of bss_desc fields
  mwifiex: scan: factor out has_ieee_hdr/has_vendor_hdr
  mwifiex: scan: simplify ternary operators using gnu extension
  mwifiex: scan: factor out dbg_security_flags
  mwifiex: scan: replace pointer arithmetic with array access
  mwifiex: factor out mwifiex_cancel_pending_scan_cmd
  mwifiex: make mwifiex_insert_cmd_to_free_q local static

 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  49 +++---
 drivers/net/wireless/marvell/mwifiex/main.h        |   3 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        | 184 +++++++--------------
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  13 +-
 4 files changed, 91 insertions(+), 158 deletions(-)

-- 
2.7.0

