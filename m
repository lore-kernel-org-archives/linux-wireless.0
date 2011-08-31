Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1HaGkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:40:41 -0400
Subject: RE: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
From: Johannes Berg <johannes@sipsolutions.net>
To: "Sumangala, Suraj" <surajs@qca.qualcomm.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>,
	"Mehta, Vipin" <vipimeht@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <480687D4EEFE7447A2E09AADFF6673621AF7CDCF@nasanexd02a.na.qualcomm.com>
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
	 (sfid-20110831_082525_612687_34CC3735),<1314772217.4161.10.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CDCF@nasanexd02a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 08:40:32 +0200
Message-ID: <1314772832.4161.16.camel@jlt3.sipsolutions.net> (sfid-20110831_084044_946742_6706EC6B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

johannes

