Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35149 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab1IAMWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 08:22:15 -0400
Message-ID: <4E5F78F1.8010900@qca.qualcomm.com> (sfid-20110901_142218_112942_B3C28C51)
Date: Thu, 1 Sep 2011 15:22:09 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: "Sumangala, Suraj" <surajs@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>,
	"Mehta, Vipin" <vipimeht@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>	 (sfid-20110831_082525_612687_34CC3735),<1314772217.4161.10.camel@jlt3.sipsolutions.net>	 <480687D4EEFE7447A2E09AADFF6673621AF7CDCF@nasanexd02a.na.qualcomm.com>	 ,<1314772832.4161.16.camel@jlt3.sipsolutions.net>	 <480687D4EEFE7447A2E09AADFF6673621AF7CE0B@nasanexd02a.na.qualcomm.com>	 <1314801657.3373.260.camel@aeonflux>	 <480687D4EEFE7447A2E09AADFF6673621AF7DF82@nasanexd02a.na.qualcomm.com>	 <1314831118.3373.266.camel@aeonflux>	 <480687D4EEFE7447A2E09AADFF6673621AF827CC@nasanexd02a.na.qualcomm.com> <1314877381.3373.284.camel@aeonflux>
In-Reply-To: <1314877381.3373.284.camel@aeonflux>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

a minor nitpick:

On 09/01/2011 02:43 PM, Marcel Holtmann wrote:
> However first we need to establish in which direction this should be
> done anyway. Should the Bluetooth subsystem notify mac80211
> unconditional or should mac80211 register notifiers of the Bluetooth
> subsystem.

Not all wireless drivers use mac80211 so this should use cfg80211 instead.

Kalle
