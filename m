Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2JOSQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 14:16:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TNpDj-000633-J2
	for linux-wireless@vger.kernel.org; Mon, 15 Oct 2012 20:16:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] cfg80211 tracing
Date: Mon, 15 Oct 2012 20:17:27 +0200
Message-Id: <1350325050-6994-1-git-send-email-johannes@sipsolutions.net> (sfid-20121015_201700_557568_E6F77C87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Since mac80211 and iwlwifi tracing was so succesful
(by being very helpful) we added tracing to cfg80211
as well. This might help debug issues with the APIs
or how they are used.

This isn't fully complete right now, I'll gladly
take patches for that or will do it myself later,
but it was just too hard to coordinate that since
I kept merging new things while Hila and Beni were
writing the tracing code.

The first patch just adds static inline wrappers to
the APIs just like in mac80211, the second fills in
the driver operation tracing and the third also adds
tracing to the APIs provided by cfg80211.

After I merge these patches, I'd like to see tracing
added to new patches, but everything that's posted
until then we can deal with later. I'll remind you
anyway ;)

johannes

