Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51993 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0EHI10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 04:27:26 -0400
Subject: Re: [RFC] minstrel_ht: refine STBC handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
In-Reply-To: <201005080241.16634.chunkeey@googlemail.com>
References: <201005080241.16634.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 May 2010 10:27:22 +0200
Message-ID: <1273307242.4051.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-05-08 at 02:41 +0200, Christian Lamparter wrote:

> I noticed that only the peer's HT capabilities are fully evaluated,
> but the actual capabilities of the sending device (stored
> in sband->ht_cap.cap) are not considered.

mac80211 will give you the peer's capabilities already restricted down
to our own.

johannes

