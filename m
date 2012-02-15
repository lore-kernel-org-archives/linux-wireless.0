Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2BOKG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:06:26 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Rxbkn-0006Zd-MV
	for linux-wireless@vger.kernel.org; Wed, 15 Feb 2012 11:06:25 +0100
Subject: FYI: mac80211 tx_sync API removal
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Feb 2012 11:06:24 +0100
Message-ID: <1329300384.3308.1.camel@jlt3.sipsolutions.net> (sfid-20120215_110630_353663_E1198652)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just in case anyone was planning to use this -- it's no longer needed
with the auth/assoc redesign and as soon as I modify iwlwifi to no
longer use it (making use of the station state callbacks) I will remove
the tx_sync API.

johannes

