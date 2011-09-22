Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1IVPtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 11:49:36 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R6lWp-0002MW-Qb
	for linux-wireless@vger.kernel.org; Thu, 22 Sep 2011 17:49:35 +0200
Message-Id: <20110922154726.521122680@sipsolutions.net> (sfid-20110922_174947_979028_29114A90)
Date: Thu, 22 Sep 2011 17:47:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 00/15] mac80211 uAPSD support
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a new set of my uAPSD support patches.
New is:
 * ps-poll and uAPSD service periods may not
   happen at the same time, this simplifies
   things and hopefully stations won't be that
   stupid ...
 * fixes a bunch of issues
 * thought about GO absence periods
 * added documentation

johannes

