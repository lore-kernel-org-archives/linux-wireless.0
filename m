Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1D2HLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 03:11:47 -0400
Subject: Re: [PATCH 1/2] wireless: Make struct ieee80211_channel const
 where possible
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <b953f08a496209fe0fb69166c5175ff270b7efc5.1304054543.git.joe@perches.com>
References: <cover.1304054543.git.joe@perches.com>
	 <b953f08a496209fe0fb69166c5175ff270b7efc5.1304054543.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 09:11:38 +0200
Message-ID: <1304061098.3589.0.camel@jlt3.sipsolutions.net> (sfid-20110429_091208_235817_410C9D4A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-28 at 22:25 -0700, Joe Perches wrote:
> Useful for declarations of static const.

I don't mind marking lots of places const, but it isn't actually as
useful as you think since you can't declare any channels const as they
are modified at runtime for regulatory enforcement.

johannes


