Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab1CAMR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 07:17:27 -0500
Subject: Re: [PATCH 4/9] [cfg80211] add preliminary radar processing code
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	nbd@openwrt.org, dubowoj@neratec.com, zefir.kurtisi@neratec.com,
	simon.wunderlich@saxnet.de
In-Reply-To: <201102281748.50054.bernhard.schmidt@saxnet.de>
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
	 <201102281748.50054.bernhard.schmidt@saxnet.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 13:17:25 +0100
Message-ID: <1298981845.6015.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 17:48 +0100, Bernhard Schmidt wrote:

> +static struct radar radar;

Didn't you just say you no longer had any global state???

johannes

