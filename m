Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0KXHVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 02:21:32 -0500
Subject: Re: [PATCH 1/2] cfg80211: Add new BSS attribute ht_opmode
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1290166826-27063-1-git-send-email-helmut.schaa@googlemail.com>
References: <1290166826-27063-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 08:21:29 +0100
Message-ID: <1290583289.3790.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-19 at 12:40 +0100, Helmut Schaa wrote:
> Add a new BSS attribute to allow hostapd to set the current HT opmode.
> Otherwise drivers won't be able to set up protection for HT rates in
> AP mode.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 
> Not sure if we also want to pass in some other parts of the HT Operation
> IE or maybe the whole IE?
> 
> At the moment the HT opmode is sufficient but in the future we might
> want to support STBC beaconing and so on. Passing the whole IE would
> not require any new interfaces later but also makes the interface less
> nice IMO :)
> 
> I'll send a patch for hostapd as soon as the interface is agreed on.

This seems fine to me. Any opinion from Jouni?

johannes


