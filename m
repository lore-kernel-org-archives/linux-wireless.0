Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ivanich.tenet.odessa.ua ([85.238.100.22]:39145 "EHLO
	ivanich.org.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab2GDJP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 05:15:28 -0400
Received: from [85.238.97.154] (helo=ivanich.localnet)
	by ivanich.org.ua with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <ivanich@ivanich.org.ua>)
	id 1SmLgC-0000id-Mj
	for linux-wireless@vger.kernel.org; Wed, 04 Jul 2012 12:15:24 +0300
From: Ivanich <ivanich@ivanich.org.ua>
To: linux-wireless@vger.kernel.org
Subject: Regression in the latest wireless-testing
Date: Wed, 04 Jul 2012 12:15:26 +0300
Message-ID: <1957616.7uPhIQSMg3@ivanich> (sfid-20120704_111531_606828_5863F079)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to stop or restart hostapd it says that it could't be stoped and 
it isn't possible to kill hostapd process, it running with -Ds status, also it 
causes problems with all network interfaces, for example ifconfig command 
froze, and can't even reboot without SysRq.
Tried clean 3.5.0-rc5-git - it works correctly. I'm using rtl8192ce in AP 
mode.
