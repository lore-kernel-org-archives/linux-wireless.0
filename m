Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:46463 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab1AYRwC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 12:52:02 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-36.nexicom.net [216.168.118.36])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p0PHpvrk007212
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 12:51:58 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 1A50298479
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 12:51:57 -0500 (EST)
Message-ID: <4D3F0DBC.90302@lockie.ca>
Date: Tue, 25 Jan 2011 12:51:56 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: LIBIPW
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

/usr/src/compat-wireless-2011-01-24 $ sudo make
/usr/src/compat-wireless-2011-01-24/config.mk:202: "WARNING:
CONFIG_CFG80211_WEXT will be deactivated or not working because kernel
was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface like
iwconfig will not work. To activate it build your kernel e.g. with
CONFIG_LIBIPW=m."

$ sudo grep LIBIPW ../linux/.config
''

What does LIBIPW depend on?
I don't even see a choice to turn it on.
