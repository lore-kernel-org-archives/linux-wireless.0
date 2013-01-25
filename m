Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab3AYORm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 09:17:42 -0500
Message-ID: <1359123477.4655.9.camel@jlt4.sipsolutions.net> (sfid-20130125_151801_222080_4A6A95E5)
Subject: Re: [PATCH 16/19] mac80211: avoid a build warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 25 Jan 2013 15:17:57 +0100
In-Reply-To: <1359123276-15833-17-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
	 <1359123276-15833-17-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-25 at 14:14 +0000, Arnd Bergmann wrote:
> gcc cannot prove that the value of sdata->vif.type does not
> change between the switch() statement and the second
> comparison to NL80211_IFTYPE_AP, causing a harmless
> warning.
> Slightly reordering the code makes the warning go away
> with no functional change.

Thanks!

Applied.

johannes

