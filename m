Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:20546 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZAYV2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 16:28:13 -0500
Received: from tad.lat (unknown [216.113.200.202])
	by raf.campcoop.com (Postfix) with ESMTPSA id 1A562BFABE
	for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 13:11:23 -0800 (PST)
Received: from jablko by tad.lat with local (Exim 4.69)
	(envelope-from <ms419@freezone.co.uk>)
	id 1LRCMy-0001lg-8b
	for linux-wireless@vger.kernel.org; Sun, 25 Jan 2009 13:18:16 -0800
Subject: [PATCH] compat-wireless-old redefinition of
	'ieee80211_install_qdisc'
From: Jack Bates <ms419@freezone.co.uk>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sun, 25 Jan 2009 13:18:15 -0800
Message-Id: <1232918295.3448.9.camel@tad.lat> (sfid-20090125_222817_426053_CB08333C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://cgi.sfu.ca/~jdbates/tmp/linux/200901250/patch

I installed Debian Lenny on my new Eee PC 1000HA this weekend, and to
get the Atheros AR242x working, I compiled the compat-wireless-old
package.

I installed the Debian linux-headers-2.6.26-1-686 package, version
2.6.26-13 but got errors such as this compiling compat-wireless-old:

[...]/wme.c:594: error: redefinition of 'ieee80211_install_qdisc'
[...]/wme.h:39: error: previous definition of 'ieee80211_install_qdisc'
was here

After applying the linked patch to wme.c, I successfully compiled
compat-wireless-old, and am sending this message from my Eee PC with
wireless : )
