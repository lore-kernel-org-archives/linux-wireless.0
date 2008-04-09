Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:35213 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbYDIWN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 18:13:26 -0400
Received: by ug-out-1314.google.com with SMTP id z38so1139024ugc.16
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2008 15:13:24 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: mac80211 ifup & ifdown
Date: Thu, 10 Apr 2008 00:17:23 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804100017.23359.IvDoorn@gmail.com> (sfid-20080409_231348_935405_D8449F27)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think I recently saw some discussion about mac80211 having a bug
when the interface was brought down and back up again which would
leave mac80211 & driver in a state from which it could no longer be
able to associate again.

I can't find the particular email again, but was this issue indeed a bug
with mac80211? And if so, is that bug present in 2.6.25 or only in
wireless-testing?

Thanks,

Ivo
