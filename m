Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58751 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756139AbYLLMjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 07:39:23 -0500
Message-Id: <20081212123832.506588839@atheros.com> (sfid-20081212_133930_201346_2C268D87)
Date: Fri, 12 Dec 2008 14:38:32 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211: HT rate reporting in RX status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series enhances the driver API to allow HT rates to be reported
to mac80211. The first patch includes the needed changes for mac80211
and the second one changes ath9k to use the new variables. The third
patch updates the radiotap format based on the version used in
FreeBSD. This is also supported by wireshark.

I would like to get the first two patches into the upstream kernel
releases, but the third one could remain only in wireless-testing
until the radiotap fields have been standardized more officially.
Anyway, these have been used in FreeBSD for ages and I would also be
fine with just including this in Linux releases as-is.

-- 
Jouni Malinen                                            PGP id EFC895FA
