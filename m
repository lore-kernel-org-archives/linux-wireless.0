Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f26.google.com ([209.85.220.26]:60572 "EHLO
	mail-fx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZAHM3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 07:29:41 -0500
Received: by fxm7 with SMTP id 7so1626870fxm.13
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 04:29:39 -0800 (PST)
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for management frames
Date: Thu, 8 Jan 2009 13:29:16 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Dan Williams <dcbw@redhat.com>
References: <20090107112346.369581673@atheros.com> <200901081308.23046.helmut.schaa@gmail.com> <20090108121839.GA20687@jm.kir.nu>
In-Reply-To: <20090108121839.GA20687@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901081329.16851.helmut.schaa@gmail.com> (sfid-20090108_132946_350185_7DA83C77)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 8. Januar 2009 schrieb Jouni Malinen:
> However, at this point I would not yet
> recommend trying to use driver_nl80211 as the first option. Once we get 
> nl80211 bit more complete and at least make sure it does not break
> something, adding the automatic driver selection would sound more
> reasonable.

Right. Sounds feasible.

> Though, this would also mean that we depend on drivers never 
> implementing partial nl80211 support that could trigger wpa_supplicant
> into believing that they support nl80211 when they would actually work
> much better with wext.

Good point.

Helmut
