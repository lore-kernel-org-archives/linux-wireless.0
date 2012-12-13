Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:40906
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751414Ab2LMFsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 00:48:12 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20681.27637.559013.79620@gargle.gargle.HOWL> (sfid-20121213_064816_229729_77FA28C9)
Date: Thu, 13 Dec 2012 11:17:33 +0530
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
In-Reply-To: <50C95F06.9090702@qca.qualcomm.com>
References: <1354880763-12309-1-git-send-email-vthiagar@qca.qualcomm.com>
	<1354880763-12309-2-git-send-email-vthiagar@qca.qualcomm.com>
	<1355255841.9819.18.camel@jlt4.sipsolutions.net>
	<50C81331.9080304@qca.qualcomm.com>
	<1355311595.9708.2.camel@jlt4.sipsolutions.net>
	<50C95F06.9090702@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan wrote:
> Here the white and black list are real white and black list.
> The mac address listed under white list are allowed to connect
> while the ones available on black are blocked unconditionally
> from connection. If a station's mac is part of neither of the lists,
> that needs to be notified which is missing now. It is not very clear
> to me about how the notification needs to be done, is it through
> NL80211_ATTR_CONN_FAILED_REASON in NL80211_CMD_CONN_FAILED or
> there needs to be new command/attr?.

What if an address is part of both the lists ? :)

Sujith
