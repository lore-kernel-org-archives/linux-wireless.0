Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3BMXsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 18:48:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, green@qca.qualcomm.com
Subject: [PATCH v2 0/3] VHT regulatory
Date: Thu, 14 Feb 2013 00:47:51 +0100
Message-Id: <1360799274-16088-1-git-send-email-johannes@sipsolutions.net> (sfid-20130214_004803_962609_48A53F0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now with a patch to advertise this in nl80211, so
wpa_s can stop parsing the regulatory information
(if the new capability is present.)

johannes

