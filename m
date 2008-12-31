Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46664 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756733AbYLaPmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 10:42:07 -0500
Message-Id: <20081231153834.840526845@w1.fi> (sfid-20081231_164219_539809_2A0B1B7E)
Date: Wed, 31 Dec 2008 17:38:34 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 00/11] mac80211: Add support for IEEE 802.11w (MFP)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches adds support for IEEE 802.11w (management frame
protection) into mac80211. It is up-to-date with the latest IEEE 802.11w
draft (D7.0) and I do not expect any major changes to IEEE 802.11w
anymore.

The main differences to the last RFC round:
- resync with current mac80211
- update to latest IEEE 802.11w draft (D6.0 -> D7.0)
  (protection against unauthorized (re)association attacks with
   SA Query procedure and Association Comeback notification;
   exclude Public Action frames from MFP)

-- 
Jouni Malinen                                            PGP id EFC895FA
