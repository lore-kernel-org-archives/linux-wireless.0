Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39168 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbYH2RSD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 13:18:03 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] cfg80211: allow more than one regulatory request
Date: Fri, 29 Aug 2008 10:17:54 -0700
Message-ID: <1220030278-6088-1-git-send-email-lrodriguez@atheros.com> (sfid-20080829_191812_362541_C56AC9E5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series preps up the wireless core for allowing
multiple requests for setting the regulatory domain
with a few updates and and finally adds support for
letting the user set the regulatory domain.

If you want to set the regulatory domain you can use iw as
follows:

iw reg set CR

Patch for iw will be submitted after this series.

After this I will tackle 802.11d parsing and integration
along with regulatory intersection capabilities.

  Luis
