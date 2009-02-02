Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17757 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZBBKlS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 05:41:18 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 02:41:18 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18822.52467.696878.818612@gargle.gargle.HOWL> (sfid-20090202_114122_182016_DBA502A0)
Date: Mon, 2 Feb 2009 16:07:39 +0530
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Extend the rate control API with an update callback
In-Reply-To: <18822.51903.216795.888284@gargle.gargle.HOWL>
References: <18822.51903.216795.888284@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> The AP can switch dynamically between 20/40 Mhz channel width,
> in which case we switch the local operating channel, but the
> rate control algorithm is not notified. This patch adds a new callback
> to indicate such changes to the RC algorithm.
> 
> Currently, HT channel width change is notified, but this callback
> can be used to indicate any new requirements that might come up later on.
> 

This is an RFC, of course. :)

Sujith
