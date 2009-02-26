Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:49185 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676AbZBZXdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 18:33:01 -0500
Message-ID: <49A726A9.7060503@lwfinger.net> (sfid-20090227_003305_974762_43835444)
Date: Thu, 26 Feb 2009 17:32:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
CC: Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Tests of open-source firmware 2/25-26
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Francesco,

With the RX queue set at 64 and the TX queue at 32, my system has been running
V5.1 open firmware for nearly 32 hours without a glitch. This is much longer
than any previous run.

The TX status queue has only reached a maximum of 14. As far as I know, the
failures have only occurred after that queue has reached the 16 entry limit.

I will leave the test running until you have a firmware patch to test.

Larry
