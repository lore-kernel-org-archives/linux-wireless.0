Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46732 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbbFQIlS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:41:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA256:128)
	(Exim 4.85)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Z58uL-0005DW-HS
	for linux-wireless@vger.kernel.org; Wed, 17 Jun 2015 10:41:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 00/14] mac80211: various cleanups
Date: Wed, 17 Jun 2015 10:41:01 +0200
Message-Id: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net> (sfid-20150617_104123_413659_96A2AD6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for my multi-queue RX work, I went through some code
to make this easier to handle. One thing that I wanted to do as part
of this was reorganise the station struct to be more cache-efficient,
but for now this just has the mesh code moving out of it, the other
part is still WIP.

(if this should conflict with any other pending patches, I'll fix)

johannes

