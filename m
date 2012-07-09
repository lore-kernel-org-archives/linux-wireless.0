Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab2GIMiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 08:38:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SoDE5-00046H-Oi
	for linux-wireless@vger.kernel.org; Mon, 09 Jul 2012 14:38:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] cfg80211: P2P Device preparations
Date: Mon,  9 Jul 2012 14:37:55 +0200
Message-Id: <1341837483-18001-1-git-send-email-johannes@sipsolutions.net> (sfid-20120709_143817_636734_7547BD83)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are pretty much standalone so I'm going to apply them
before actually implementing the P2P Device abstraction,
mostly to reduce conflicts.

johannes

