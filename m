Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41622 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbaJFO2U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 10:28:20 -0400
Message-ID: <1412605698.3098.19.camel@jlt4.sipsolutions.net> (sfid-20141006_162823_858970_25337D61)
Subject: Re: [PATCH v2 4/4] hwsim:  support creating wiphy w/out creating
 wlanX.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Oct 2014 16:28:18 +0200
In-Reply-To: <1411773856-25042-4-git-send-email-greearb@candelatech.com> (sfid-20140927_012440_871377_8AAD11F5)
References: <1411773856-25042-1-git-send-email-greearb@candelatech.com>
	 <1411773856-25042-4-git-send-email-greearb@candelatech.com>
	 (sfid-20140927_012440_871377_8AAD11F5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You also really need to work on the subject prefixes...

They should be
1) cfg80211
2) mac80211-hwsim:
3) mac80211:
4) mac80211-hwsim:

johannes


