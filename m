Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1HHIdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 04:33:12 -0400
Subject: Re: [PATCH] mac80211_hwsim: Fix RX status reporting for HT
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110806200700.GA13221@jm.kir.nu> (sfid-20110806_220724_927097_CF02E140)
References: <20110806200700.GA13221@jm.kir.nu>
	 (sfid-20110806_220724_927097_CF02E140)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 10:33:08 +0200
Message-ID: <1312792388.4372.6.camel@jlt3.sipsolutions.net> (sfid-20110808_103315_870077_BA6014BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-08-06 at 23:07 +0300, Jouni Malinen wrote:
> RX_FLAG_HT must be included when reporting MCS rates. Without
> this, mac80211 ended up dropping any frame sent at MCS index 12
> or higher and that resulted in oddly random looking errors in
> mac80211_hwsim tests.

This "solved" the timing thing you ran into with the unrelated
suspend/resume patch then I guess?

johannes

