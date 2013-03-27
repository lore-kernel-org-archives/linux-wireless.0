Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3C0Qv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:51:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UKtZO-0000RG-9z
	for linux-wireless@vger.kernel.org; Wed, 27 Mar 2013 17:51:26 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/3] mac80211: some queue management fixes
Date: Wed, 27 Mar 2013 17:51:19 +0100
Message-Id: <1364403082-20722-1-git-send-email-johannes@sipsolutions.net> (sfid-20130327_175133_291468_17629EA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These aren't really all that important, but it seems the per-netdev
queue management is somewhat buggy. This is an attempt to fix it :)

johannes

