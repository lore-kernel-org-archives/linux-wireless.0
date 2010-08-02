Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0HBLBi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 07:01:38 -0400
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <4C56A251.7080903@openwrt.org>
References: <20100729035820.5930.29864.stgit@tt-desk>
	 <201007291812.28639.br1@einfach.org>
	 <AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com>
	 <201008021313.54850.br1@einfach.org>
	 <AANLkTimRnfa8HVpi0hcP7Eo9Nrns60ff3Hs+fq39WoJh@mail.gmail.com>
	 <4C5688F7.1070200@openwrt.org>
	 <AANLkTi=Qm53CgFNNgtF4iBvh3jbfYzd8XPH4y9ysUaoV@mail.gmail.com>
	 <4C568D23.2000203@openwrt.org>
	 <AANLkTinGdwt4bSPRDV=ZfPBmoKS42GgUVjLAg_O1vL3i@mail.gmail.com>
	 <4C5690C7.2080104@openwrt.org>
	 <AANLkTimoU+iF2bVJ-Fs4iT3k5v0iU9PaE783NhUdnQQ-@mail.gmail.com>
	 <4C5699AE.6090103@openwrt.org>
	 <AANLkTimWnefNaiPzqMXwc6d8aePmy3SZ8w9FB4=6CRko@mail.gmail.com>
	 <4C56A251.7080903@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 13:01:33 +0200
Message-ID: <1280746893.3923.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-02 at 12:47 +0200, Felix Fietkau wrote:

> Legacy hardware  => run time changes possible (actually optional)
> 802.11n hardware => need to bring down the interface before changing
>                     the antenna settings

I think I'd prefer if all hw just required the device to be stopped.
Otherwise things either become awkward when you have, say. software
diversity control, or they become unpredictable quite, no?

johannes

