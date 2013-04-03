Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760148Ab3DCMZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:25:25 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UNMkl-0004VW-OC
	for linux-wireless@vger.kernel.org; Wed, 03 Apr 2013 14:25:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211: fixes for do_stop while suspended
Date: Wed,  3 Apr 2013 14:25:17 +0200
Message-Id: <1364991920-11712-1-git-send-email-johannes@sipsolutions.net> (sfid-20130403_142528_316378_A6E9C1A9)
In-Reply-To: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
References: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inspired by Stanislaw's patches, I took another look. He tested my
RFC series and while there were still issues it looks better now,
so we're going to apply this. Speak up if you don't want that! :)

johannes

