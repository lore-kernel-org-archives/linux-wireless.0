Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ivanich.tenet.odessa.ua ([85.238.100.22]:41889 "EHLO
	ivanich.org.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab2GSIyl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 04:54:41 -0400
Received: from [85.238.97.154] (helo=ivanich.localnet)
	by ivanich.org.ua with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <ivanich@ivanich.org.ua>)
	id 1SrmVK-0002Hv-Sx
	for linux-wireless@vger.kernel.org; Thu, 19 Jul 2012 11:54:38 +0300
From: Ivanich <ivanich@ivanich.org.ua>
To: linux-wireless@vger.kernel.org
Subject: hostapd locks during restart
Date: Thu, 19 Jul 2012 11:54:48 +0300
Message-ID: <1375660.IC4Ixsn6lK@ivanich> (sfid-20120719_105446_023362_E09E81DC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the latest wireless-testing.git hostapd deadlock during restart, using 
rtl8192ce in AP mode.
