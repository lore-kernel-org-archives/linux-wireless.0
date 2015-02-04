Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:59787 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966624AbbBDQqB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 11:46:01 -0500
Message-ID: <54D24CC3.9010006@users.sourceforge.net> (sfid-20150204_174606_946966_4CFCC8A2)
Date: Wed, 04 Feb 2015 17:45:55 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>,
	Solomon Peachy <pizza@shaftnet.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/2] CW1200: Deletion of an unnecessary check
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 4 Feb 2015 17:31:00 +0100

Another update suggestion was taken into account after a patch was applied
from static source code analysis.

Markus Elfring (2):
  Delete an unnecessary check before the function call "release_firmware"
  Less function calls in cw1200_load_firmware_cw1200() after error detection

 drivers/net/wireless/cw1200/fwio.c | 40 +++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 16 deletions(-)

-- 
2.2.2

