Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:60386 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbcABUv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 15:51:29 -0500
Subject: [PATCH 0/3] NFC-mei_phy: Fine-tuning for two function implementations
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-wireless@vger.kernel.org,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <56883849.2080304@users.sourceforge.net> (sfid-20160102_215200_666808_CE5F87ED)
Date: Sat, 2 Jan 2016 21:51:21 +0100
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Jan 2016 21:47:30 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Refactoring for mei_nfc_connect()
  Refactoring for mei_nfc_if_version()
  Delete an unnecessary variable initialisation in mei_nfc_if_version()

 drivers/nfc/mei_phy.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

-- 
2.6.3

