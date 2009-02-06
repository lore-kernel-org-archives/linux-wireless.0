Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:46306 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759150AbZBFPq0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 10:46:26 -0500
Received: from localhost
	([127.0.0.1] helo=[192.168.1.171] ident=sslwrap)
	by element.ksp.sk with esmtp (Exim 4.69)
	(envelope-from <milan.plzik@gmail.com>)
	id 1LVSRV-00066B-FL
	for linux-wireless@vger.kernel.org; Fri, 06 Feb 2009 16:16:33 +0100
Subject: AP mode support requirements for iwlagn driver
From: Milan Plzik <milan.plzik@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 06 Feb 2009 16:16:32 +0100
Message-Id: <1233933392.6476.2372.camel@localhost> (sfid-20090206_164648_314946_F5B48388)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Hello,

  what are the exact requirements for AP mode support in iwlagn driver?
Is there any change neccessary in card's firmware, or the only missing
code is in mac80211/iwlagn itself? Also, there was sort-of support for
AP, but it was disabled in later versions -- what were the exact
problems with this implementation?

  Best regards,
	Milan Plzik


