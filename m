Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48140 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab1HaGhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:37:01 -0400
From: "Sumangala, Suraj" <surajs@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>,
	"Mehta, Vipin" <vipimeht@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
Date: Wed, 31 Aug 2011 06:36:03 +0000
Message-ID: <480687D4EEFE7447A2E09AADFF6673621AF7CDCF@nasanexd02a.na.qualcomm.com> (sfid-20110831_083706_748448_63F2E99F)
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
	 (sfid-20110831_082525_612687_34CC3735),<1314772217.4161.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1314772217.4161.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi johannes,
________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Wednesday, August 31, 2011 12:00 PM
To: Sumangala, Suraj
Cc: linville@tuxdriver.com; ath6kl-devel; Balasubramanian, senthilkumar; Mehta, Vipin; Valo, Kalle; linux-wireless@vger.kernel.org
Subject: Re: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex

On Wed, 2011-08-31 at 11:55 +0530, Suraj Sumangala wrote:
> This patch propose a new set of NL80211 commands and attributes
> to communicate information about ongoing Bluetooth operations to the
> wifi chip in case of a Bluetooth-WiFi coex solution.
>
> It can then be used by the WiFi hardware to understand the requirements
> of a Bluetooth radio and manage shared resources between
> Bluetooth and Wifi modules better.
>
> The proposed Bluetooth information sent are mainly regarding Bluetooth
> SCO, A2DP connection, inquiry and master/slave role of Bluetooth chip.
>
> This information can be sent by a userspace Bluetooth filter utility
> application to the WiFi driver.

???
Why would this need a userspace utility? Are you cloning some sort of
windows architecture here?

johannes

It will be the userpace bluez dbus events that can provide information regarding the status of variout Bluetooth events.
On receiving that information, it can send corresponding NL80211 command.

Regards
Suraj
