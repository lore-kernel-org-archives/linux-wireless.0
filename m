Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481AbaDIHtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 03:49:49 -0400
Message-ID: <1397029770.4964.2.camel@jlt4.sipsolutions.net> (sfid-20140409_094953_110924_E61EA865)
Subject: Re: [PATCH 8/8] cfg80211: remove unnecessary include clauses
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Apr 2014 09:49:30 +0200
In-Reply-To: <c02aba28b27fe39da9730cd965e322054815713f.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032913_086421_21E1A53B)
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	 <c02aba28b27fe39da9730cd965e322054815713f.1397006688.git.gamerh2o@gmail.com>
	 (sfid-20140409_032913_086421_21E1A53B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't like those last four patches, I'd rather have more includes than
rely on other headers including headers that we need - that could change
after all.

johannes

