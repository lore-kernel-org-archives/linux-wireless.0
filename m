Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2G0MSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 08:18:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SujV0-0007Bs-Mo
	for linux-wireless@vger.kernel.org; Fri, 27 Jul 2012 14:18:30 +0200
Message-ID: <1343391506.4449.11.camel@jlt3.sipsolutions.net> (sfid-20120727_141835_704102_16DF2710)
Subject: driver sparse/smatch warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 27 Jul 2012 14:18:26 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since I was just running sparse & smatch anyway I figured I'd post it in
case somebody is interested:

http://p.sipsolutions.net/04cc4db35c4e5793.txt

Drivers with seemingly relevant warnings are:
 * ath9k (bad spin_lock_bh)
 * b43 (some functions can be static)
 * iwlegacy (lots of functions can be static)
 * p54
 * rt2x00 maybe?
 * rtlwifi (null deref, endian warnings)
 * at76c (dma on stack)


johannes

