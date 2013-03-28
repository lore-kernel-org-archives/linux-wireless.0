Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab3C1JtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 05:49:11 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UL9SH-0007c9-B1
	for linux-wireless@vger.kernel.org; Thu, 28 Mar 2013 10:49:09 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/9] mac80211: channel switch handling
Date: Thu, 28 Mar 2013 10:48:56 +0100
Message-Id: <1364464145-14446-1-git-send-email-johannes@sipsolutions.net> (sfid-20130328_104914_858576_1EA2BA53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix HT channel switch handling by parsing the secondary channel
offset properly. Also react to all the different action frames
that are defined now. Finally, implement VHT channel switch in
mac80211.

Haven't been able to test this at all yet though ...

johannes

