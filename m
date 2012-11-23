Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907Ab2KWHmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 02:42:32 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TbnuB-0004FL-Iq
	for linux-wireless@vger.kernel.org; Fri, 23 Nov 2012 08:42:32 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211: some HT fixes/cleanups
Date: Fri, 23 Nov 2012 08:42:57 +0100
Message-Id: <1353656580-12134-1-git-send-email-johannes@sipsolutions.net> (sfid-20121123_084235_819167_70339120)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While working on VHT support I found a few small issues with
the HT support, fix these and also rename the DISABLE_11N
flag to DISABLE_HT to make it less confusing.

johannes

