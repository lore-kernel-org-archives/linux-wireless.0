Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab3CZNgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 09:36:08 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UKU2o-0000GM-Hk
	for linux-wireless@vger.kernel.org; Tue, 26 Mar 2013 14:36:06 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/4] mac80211: proper channel switch support
Date: Tue, 26 Mar 2013 14:35:57 +0100
Message-Id: <1364304961-32028-1-git-send-email-johannes@sipsolutions.net> (sfid-20130326_143613_115063_8EB7C194)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current channel switch support is rather lacking, HT channel switch
isn't even attempted to be handled correctly ... This makes it a bit more
complete, though still lacking VHT and channel context handling.

Does anyone have a test setup for this?

johannes

