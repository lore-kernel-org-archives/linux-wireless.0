Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36765 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab1IAMUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 08:20:10 -0400
Subject: RE: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Sumangala, Suraj" <surajs@qca.qualcomm.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>,
	"Mehta, Vipin" <vipimeht@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1314877381.3373.284.camel@aeonflux>
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
	 (sfid-20110831_082525_612687_34CC3735),<1314772217.4161.10.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CDCF@nasanexd02a.na.qualcomm.com>
	 ,<1314772832.4161.16.camel@jlt3.sipsolutions.net>
	 <480687D4EEFE7447A2E09AADFF6673621AF7CE0B@nasanexd02a.na.qualcomm.com>
	 <1314801657.3373.260.camel@aeonflux>
	 <480687D4EEFE7447A2E09AADFF6673621AF7DF82@nasanexd02a.na.qualcomm.com>
	 <1314831118.3373.266.camel@aeonflux>
	 <480687D4EEFE7447A2E09AADFF6673621AF827CC@nasanexd02a.na.qualcomm.com>
	 <1314877381.3373.284.camel@aeonflux>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 14:20:02 +0200
Message-ID: <1314879602.4022.1.camel@jlt3.sipsolutions.net> (sfid-20110901_142014_247740_E241C6C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-01 at 04:43 -0700, Marcel Holtmann wrote:

> We also should not forget direct integration support for changing AFH
> channel maps based on the used WiFi channels.

I would really prefer to see that first, much simpler and it gives us an
idea of how to work across BT/wifi subsystems.

johannes

