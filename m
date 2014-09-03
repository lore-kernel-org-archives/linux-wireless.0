Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60769 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbaICLmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 07:42:22 -0400
Message-ID: <1409744533.911.1.camel@jlt4.sipsolutions.net> (sfid-20140903_134226_427711_C80A2BAB)
Subject: Re: [PATCH] mac80211: Format connected time
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <matteo@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Sep 2014 13:42:13 +0200
In-Reply-To: <CAFnufp09nXuaobS_u7Bh5JcLGgpkPfMbqMfG0HVJYd_mLVR49A@mail.gmail.com> (sfid-20140901_105558_706822_D508DFA9)
References: <CAFnufp09nXuaobS_u7Bh5JcLGgpkPfMbqMfG0HVJYd_mLVR49A@mail.gmail.com>
	 (sfid-20140901_105558_706822_D508DFA9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seems like a good enough change, but the subject is misleading - it
was formatted before, just not in a nice way :)

Also, your patch doesn't apply (otherwise I would've fixed it up myself)

johannes


