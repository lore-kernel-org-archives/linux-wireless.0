Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2K2MRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 07:17:13 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Te33I-0006J9-1J
	for linux-wireless@vger.kernel.org; Thu, 29 Nov 2012 13:17:12 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] mac80211: improve probe request building
Date: Thu, 29 Nov 2012 13:17:34 +0100
Message-Id: <1354191456-29577-1-git-send-email-johannes@sipsolutions.net> (sfid-20121129_131720_913143_52969856)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One patch to make it safer and one to remove the temporary
allocation.

johannes

