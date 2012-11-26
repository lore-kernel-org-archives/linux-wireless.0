Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab2KZOYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 09:24:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tczc9-0003rb-Ck
	for linux-wireless@vger.kernel.org; Mon, 26 Nov 2012 15:24:49 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211: VHT managed mode & radiotap support
Date: Mon, 26 Nov 2012 15:25:12 +0100
Message-Id: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net> (sfid-20121126_152456_069102_60283804)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For managed mode, we have to parse the VHT operation IE to
determine what the channel setting should be, and then take
into account local capabilities for the channel to use,
possibly disabling some capabilities due to regulatory.

Also add some radiotap support so we differentiate VHT from
other (HT or legacy) frames.

johannes

