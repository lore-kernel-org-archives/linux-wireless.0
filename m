Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57094 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554Ab1DZHKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 03:10:25 -0400
Subject: Re: [PATCH] mac80211: Add new API for rate selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <19894.22299.697156.637717@gargle.gargle.HOWL> (sfid-20110426_072236_723033_E8A04CCF)
References: <19894.22299.697156.637717@gargle.gargle.HOWL>
	 (sfid-20110426_072236_723033_E8A04CCF)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 09:10:23 +0200
Message-ID: <1303801823.3855.0.camel@jlt3.sipsolutions.net> (sfid-20110426_091028_456077_CF6EA30F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-26 at 10:54 +0530, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> This patch adds a new API for setting a TX rate mask in
> drivers that have rate control in either the firmware or hardware.
> This can be used for various purposes, for example, masking out the
> 11b rates in P2P operation.

Nice, thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes


