Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ivanich.tenet.odessa.ua ([85.238.100.22]:44918 "EHLO
	ivanich.org.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2DPWTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:19:32 -0400
Received: from mail.ivanich.od.ua ([85.238.100.22] helo=ivanich.org.ua)
	by ivanich.org.ua with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <spams@ivanich.org.ua>)
	id 1SJtqc-0005SQ-Ay
	for linux-wireless@vger.kernel.org; Tue, 17 Apr 2012 00:52:34 +0300
From: spams@ivanich.org.ua
To: linux-wireless@vger.kernel.org
Subject: Regression in kernel-3.4-rcx with rtl8192ce
Date: Tue, 17 Apr 2012 00:52:23 +0300
Message-ID: <2054318.iQACctbcH2@ivanich.org.ua> (sfid-20120417_001936_283344_0382ED37)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using rtl8188ce in AP mode with hostapd, after upgrade to 3.4-rcx 
kernel(tried 3.4-rc2,rc3 and latest source from wireless-next.git) I can't 
connect to my AP.
AP Log:
Apr 16 23:31:39 localhost hostapd: wlan0: STA d8:b3:cf:d1:a0:58 IEEE 802.11: 
authenticated
Apr 16 23:31:39 localhost hostapd: wlan0: STA d8:b3:cf:d1:a0:58 IEEE 802.11: 
Station sent an invalid association request

Tried disabling and enabling different options in hostapd.conf but with no 
luck. With kernels-3.3.x it works just fine.
Thank you. 
