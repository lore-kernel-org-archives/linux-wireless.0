Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16791 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1HaGtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:49:01 -0400
From: "Sumangala, Suraj" <surajs@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>,
	"Mehta, Vipin" <vipimeht@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
Date: Wed, 31 Aug 2011 06:48:59 +0000
Message-ID: <480687D4EEFE7447A2E09AADFF6673621AF7CE0B@nasanexd02a.na.qualcomm.com> (sfid-20110831_084906_727000_41E9DAC9)
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
	 (sfid-20110831_082525_612687_34CC3735),<1314772217.4161.10.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CDCF@nasanexd02a.na.qualcomm.com>,<1314772832.4161.16.camel@jlt3.sipsolutions.net>
In-Reply-To: <1314772832.4161.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Wednesday, August 31, 2011 12:10 PM
To: Sumangala, Suraj
Cc: linville@tuxdriver.com; ath6kl-devel; Balasubramanian, senthilkumar; Mehta, Vipin; Valo, Kalle; linux-wireless@vger.kernel.org
Subject: RE: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex

On Wed, 2011-08-31 at 06:36 +0000, Sumangala, Suraj wrote:
> Hi johannes,

> ???
> Why would this need a userspace utility? Are you cloning some sort of
> windows architecture here?

Ugh, please trim your quotes and use a useful mailer that will indent things.

> It will be the userpace bluez dbus events that can provide information
> regarding the status of variout Bluetooth events.
> On receiving that information, it can send corresponding NL80211
> command.

Doesn't the kernel's bluetooth subsystem already know anyway?

Not all of the information I believe. Things like A2DP streaming will be best known at the userspace. Also, there is no way to tap these information at the kernel subsystem right now. But, there is a clear defined way to get these information at the userspace. Also, profile based information might not be available at the kernel space. 


-Suraj