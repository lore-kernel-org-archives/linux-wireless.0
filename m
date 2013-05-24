Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57698 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab3EXGfI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 02:35:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Uflah-0001p5-8b
	for linux-wireless@vger.kernel.org; Fri, 24 May 2013 08:35:03 +0200
Received: from ABTS-KK-static-202.231.166.122.airtelbroadband.in ([ABTS-KK-static-202.231.166.122.airtelbroadband.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 May 2013 08:35:03 +0200
Received: from suman.p by ABTS-KK-static-202.231.166.122.airtelbroadband.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 24 May 2013 08:35:03 +0200
To: linux-wireless@vger.kernel.org
From: Suman Pandit <suman.p@nuevonetwork.com>
Subject: Cross compilation compat-wireless in kernel-2.6.35 for powerpc
Date: Fri, 24 May 2013 06:24:46 +0000 (UTC)
Message-ID: <loom.20130524T074945-124@post.gmane.org> (sfid-20130524_083513_626123_842602FE)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


"WARNING: CONFIG_CFG80211_WEXT will be deactivated or not working because
kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface
like iwconfig will not work. To activate it build your kernel e.g. with
CONFIG_LIBIPW=m."
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h


