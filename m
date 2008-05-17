Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:36052 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYEQOuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 10:50:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JxNjW-0004DI-D7
	for linux-wireless@vger.kernel.org; Sat, 17 May 2008 14:50:02 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2008 14:50:02 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2008 14:50:02 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: rt61pci breaks after hibernate
Date: Sat, 17 May 2008 14:39:36 +0000 (UTC)
Message-ID: <g0mqn8$56h$1@ger.gmane.org> (sfid-20080517_165020_844928_EE06EF4C)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After resuming from a hibernate to disk network packets are no longer sent
and NetworkManager shows that there is no signal. Doing ifconfig wlan1
down && ifconfig wlan1 up results in the error message "SIOCSIFFLAGS: No 
such device" being printed.

-- 
Sitsofe | http://sucs.org/~sits/

