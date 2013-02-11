Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3BKMiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 07:38:23 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4seL-0001M5-Sw
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 13:38:22 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: 
Date: Mon, 11 Feb 2013 13:38:04 +0100
Message-Id: <1360586298-15028-1-git-send-email-johannes@sipsolutions.net> (sfid-20130211_133827_344785_291C08B3)
In-Reply-To: <[PATCH 00/14] mac80211: HT/VHT handling>
References: <[PATCH 00/14] mac80211: HT/VHT handling>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches improve/fix HT handling, particularly the bandwidth
change handling that we were missing entirely and HT capability
handling (which touches many drivers, unfortunately.)

This should make the VHT handling compliant with D4.0, I hope.

johannes

