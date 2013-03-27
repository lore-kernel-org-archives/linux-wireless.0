Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3C0NkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 09:40:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UKqa9-000626-EM
	for linux-wireless@vger.kernel.org; Wed, 27 Mar 2013 14:40:01 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mac80211: IE parsing cleanups
Date: Wed, 27 Mar 2013 14:39:53 +0100
Message-Id: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net> (sfid-20130327_144008_758972_0F378272)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove some unused but parsed IEs, move length checks to make
the parser struct smaller and use a struct for the TIE.

johannes

