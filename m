Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:43996 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab1AZTej (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 14:34:39 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-36.nexicom.net [216.168.118.36])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p0QJYYxK005437
	for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 14:34:35 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 71A42984A8
	for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 14:34:34 -0500 (EST)
Message-ID: <4D40774A.608@lockie.ca>
Date: Wed, 26 Jan 2011 14:34:34 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: no CONFIG_WIRELESS_EXT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I installed compat-wireless-2011-01-25 and iwlist doesn't work but iw does.
The warning dmesg shows is "cfg80211: wext will not work because kernel
was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface,
like iwconfig will not work." which is fine BUT my kernel is compiled with
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT_SYSFS=y
and those are the only 2 'WIRELESS' anything.

I have kernel 2.6.36.3.
