Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31475 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1HaOam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 10:30:42 -0400
From: "Sumangala, Suraj" <surajs@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>,
	"Mehta, Vipin" <vipimeht@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
Date: Wed, 31 Aug 2011 14:30:40 +0000
Message-ID: <480687D4EEFE7447A2E09AADFF6673621AF7CF14@nasanexd02a.na.qualcomm.com> (sfid-20110831_163044_609843_97145A3A)
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>,<1314774883.4161.18.camel@jlt3.sipsolutions.net>
In-Reply-To: <1314774883.4161.18.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,
________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Wednesday, August 31, 2011 12:44 PM
To: Sumangala, Suraj
Cc: linville@tuxdriver.com; ath6kl-devel; Balasubramanian, senthilkumar; Mehta, Vipin; Valo, Kalle; linux-wireless@vger.kernel.org
Subject: Re: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex

On Wed, 2011-08-31 at 11:55 +0530, Suraj Sumangala wrote:


> +     NL80211_CMD_BTCOEX_INQ,
> +     NL80211_CMD_BTCOEX_SCO,
> +     NL80211_CMD_BTCOEX_A2DP,
> +     NL80211_CMD_BTCOEX_ACL_ROLE,

 > Why do you need all these commands and not just one BT config command
 > that gives everything? Need to see more of the implementation but that
 > seems pointless.

One reason I went this way is because some of the events for which commands are generated has different associated parameters associated with it.
But, I do understand your point and there is scope to club similar commands together.
I guess I will send another set of patches along with the cfg80211 callbacks.

-Suraj


