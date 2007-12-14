Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:35595 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbXLNDjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 22:39:09 -0500
Date: Thu, 13 Dec 2007 19:38:07 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>, hostap@shmoo.com,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [FYI] hostapd with mac80211 progress
Message-ID: <20071214033807.GV5698@jm.kir.nu> (sfid-20071214_033914_990691_1CAC7D03)
References: <1197512614.6558.224.camel@johannes.berg> <1ba2fa240712130635n44838ac4s5bb606e5dc27fdeb@mail.gmail.com> <1197567363.8313.31.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197567363.8313.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 13, 2007 at 06:36:03PM +0100, Johannes Berg wrote:

> Not sure if I really want to, maybe we can convince Jouni to take
> patches early if they don't break anything else?

I'm fine with patches that are either specific to driver_devicescape.c
or are clearly not breaking other driver wrappers (or core hostapd
functionality) as long as they are somehow in sync with a commonly used
Linux kernel tree. At some point, I would like to limit this to proper
kernel releases, but for the time being, any development tree should be
fine taken into account the current state of the AP support.

-- 
Jouni Malinen                                            PGP id EFC895FA
