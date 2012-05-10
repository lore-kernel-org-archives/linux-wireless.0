Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40142 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760690Ab2EJRgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 13:36:19 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 0/2] NFC fixes for 3.4
Date: Thu, 10 May 2012 19:45:50 +0200
Message-Id: <1336671952-22678-1-git-send-email-sameo@linux.intel.com> (sfid-20120510_193639_486865_D8F572BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

In case Linus does an rc7 and Dave takes more 3.4 fixes in, here are the 2
pending ones that I have for NFC
I sent the nfc.h export one yesterday, I'm including it here again.

So we have an nfc.h export to the kernel hearders, and a fix for large LLCP
frame fragments to be sent in the right order.

Samuel Ortiz (2):
  NFC: Export nfc.h to userland
  NFC: Queue I frame fragments to the LLCP sockets queue tail

 include/linux/Kbuild    |    1 +
 net/nfc/llcp/commands.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

-- 
1.7.9.1

