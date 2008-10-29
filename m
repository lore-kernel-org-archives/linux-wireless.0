Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47796 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYJ2Jam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 05:30:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 02:30:42 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18696.11429.205280.318053@gargle.gargle.HOWL> (sfid-20081029_103046_657671_BC87A429)
Date: Wed, 29 Oct 2008 14:58:05 +0530
To: Tomas Winkler <tomasw@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH 16/16] mac80211: Add a new event in
 ieee80211_ampdu_mlme_action
In-Reply-To: <1ba2fa240810290226t23bdda5cjf2c4a2716cffa5bb@mail.gmail.com>
References: <18695.60248.383916.563413@gargle.gargle.HOWL>
	<1ba2fa240810290211s16f5506cgf7c828b5c3d8aea9@mail.gmail.com>
	<18696.10706.405455.724835@gargle.gargle.HOWL>
	<1ba2fa240810290226t23bdda5cjf2c4a2716cffa5bb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> Okay this means that we pushing this buffering to driver after all.
> Otherwise mac80211 would just trigger the TX on successful ADDBA

Currently yes, the buffering is done within ath9k.

Sujith

