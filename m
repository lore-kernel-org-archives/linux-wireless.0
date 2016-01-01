Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:59997 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbcAAU16 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 15:27:58 -0500
Subject: [PATCH 0/3] net-iwlegacy: Fine-tuning for il_eeprom_init()
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5686E13F.2010309@users.sourceforge.net> (sfid-20160101_212820_865809_6337E020)
Date: Fri, 1 Jan 2016 21:27:43 +0100
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 1 Jan 2016 21:25:43 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Refactoring
  One check less after error detection
  Another refactoring

 drivers/net/wireless/intel/iwlegacy/common.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

-- 
2.6.3

