Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.234]:50657 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYGINEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:04:04 -0400
Received: by wr-out-0506.google.com with SMTP id 69so2127384wri.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 06:04:03 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/3] rt2x00 update
Date: Wed, 9 Jul 2008 15:11:14 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807091511.14288.IvDoorn@gmail.com> (sfid-20080709_150408_462811_DB0B426A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

The following 3 patches are intended on top of
the patch series "mac80211 interface (config) cleanups"
which were send to the list by Johannes.

The first one is a mac80211 bugfix for drivers that require
the sequence counting to be done in software.
The second is a minor update for CTS protection support in
rt2x00lib. There aren't any users for it at this time, but it is
small, harmless and not really worth the effor for keepin it
seperate. ;)
The last one cleans up beacon handling in rt2x00 which was
possible because of Johannes' patch series.

Ivo
