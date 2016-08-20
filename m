Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:54917 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752796AbcHTQng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Aug 2016 12:43:36 -0400
Subject: [PATCH 0/3] hostap: Fine-tuning for a few functions
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <f0cd7a82-e603-6a91-0afd-33bbd1658cab@users.sourceforge.net> (sfid-20160820_184403_575163_408B5C4C)
Date: Sat, 20 Aug 2016 18:43:16 +0200
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 20 Aug 2016 18:35:43 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Use memdup_user()
  Delete an unnecessary jump label
  Delete unnecessary variable initialisations

 .../net/wireless/intersil/hostap/hostap_ioctl.c    | 36 ++++++++--------------
 1 file changed, 12 insertions(+), 24 deletions(-)

-- 
2.9.3
