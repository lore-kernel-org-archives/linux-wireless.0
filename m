Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:56305 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933259AbdEVM6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 08:58:07 -0400
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thierry Escande <thierry.escande@collabora.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] NFC-digital: Adjustments for four function
 implementations
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <7e27a76c-de7a-22ec-cf8a-31aee2000e29@users.sourceforge.net> (sfid-20170522_150004_256226_A5EACED5)
Date: Mon, 22 May 2017 14:57:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 22 May 2017 14:50:05 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Improve a size determination in four functions
  Delete an error message for a failed memory allocation in digital_in_send()

 net/nfc/digital_core.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

-- 
2.13.0
