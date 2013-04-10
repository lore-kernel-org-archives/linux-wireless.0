Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934852Ab3DJMnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 08:43:47 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UPuNN-0001Tx-Lr
	for linux-wireless@vger.kernel.org; Wed, 10 Apr 2013 14:43:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] mac80211: improve channel switch handling
Date: Wed, 10 Apr 2013 14:43:34 +0200
Message-Id: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net> (sfid-20130410_144351_624560_74A574BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This improves channel switch handling to actually parse a lot of
the newer messages and the new bandwidth (including VHT.)

I haven't really been able to test it well, but given how broken
the code clearly is now (e.g. not handling new bandwidth) it can
hardly make it works :-)

johannes

