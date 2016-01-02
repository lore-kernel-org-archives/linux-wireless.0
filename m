Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:58596 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbcABOkw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 09:40:52 -0500
Subject: [PATCH 0/3] net-rsi: Fine-tuning for two function implementations
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5687E169.4070704@users.sourceforge.net> (sfid-20160102_154113_679734_476D1A58)
Date: Sat, 2 Jan 2016 15:40:41 +0100
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Jan 2016 15:36:25 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete unnecessary variable initialisations in rsi_send_mgmt_pkt()
  Delete unnecessary variable initialisations in rsi_send_data_pkt()
  Replace variable initialisations by assignments in rsi_send_data_pkt()

 drivers/net/wireless/rsi/rsi_91x_pkt.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

-- 
2.6.3

