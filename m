Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43018 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225Ab0JZSDn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 14:03:43 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PAns1-0007LN-1y
	for linux-wireless@vger.kernel.org; Tue, 26 Oct 2010 20:03:37 +0200
Received: from CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com ([173.34.126.150])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 20:03:37 +0200
Received: from senada by CPE0014bf4aedf8-CM00111ae2cca2.cpe.net.cable.rogers.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 20:03:37 +0200
To: linux-wireless@vger.kernel.org
From: seno <senada@t-online.de>
Subject: Re:[PATCH] rtl8187b: do not do per packet TX AGC
Date: Tue, 26 Oct 2010 18:03:28 +0000 (UTC)
Message-ID: <loom.20101026T200014-691@post.gmane.org>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com> <4C798080.8010002@lwfinger.net> <20100830141218.GB30864@tuxdriver.com> <4C7BC4D9.1010108@lwfinger.net> <20100830152841.GB2950@barata.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried that patch on compat-wireless-2010-10-25 (Kernel 2.6.33.7).

Performance improves minimal, but thousands of errors occur in iwconfig output.
(Tx excessive retries, Invalid misc, Missed beacon).

The router also shows lots of errors 
(for Received (RX) / Transmitted (TX) packets)

