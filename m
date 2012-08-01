Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab2HAPVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 11:21:31 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Swajq-0000u2-Hw
	for linux-wireless@vger.kernel.org; Wed, 01 Aug 2012 17:21:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/8] channel switch improvements
Date: Wed,  1 Aug 2012 17:21:19 +0200
Message-Id: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net> (sfid-20120801_172135_485039_3F6BF73C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 currently doesn't support extended channel switch
and also doesn't handle failures well.

Support extended channel switch when the operating class 
is one of the global operating classes, and handle any
failures by disconnecting from the network.

This is completely untested so far, does anyone have a
good test environment for this kind of thing?

johannes

