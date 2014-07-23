Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56526 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbaGWLrT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 07:47:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA256:128)
	(Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <johannes@sipsolutions.net>)
	id 1X9v0v-0004O8-Ub
	for linux-wireless@vger.kernel.org; Wed, 23 Jul 2014 13:47:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/2] APIs for TSPEC setup for admission control
Date: Wed, 23 Jul 2014 13:47:04 +0200
Message-Id: <1406116026-27514-1-git-send-email-johannes@sipsolutions.net> (sfid-20140723_134723_161418_1B6F4E56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some APIs - the device is responsible for most things and
mac80211 just skips the downgrade if a session is active that
is on an admission-control AC.


