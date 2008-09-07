Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60303 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbYIGA5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 20:57:33 -0400
Subject: Re: [PATCH] Ath9k: Add RF kill support.
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <1220721572.10102.0.camel@johannes.berg>
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com>
	 <1220721347.6714.114.camel@californication>
	 (sfid-20080906_191538_728310_1EC0FE5D)  <1220721572.10102.0.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 02:57:50 +0200
Message-Id: <1220749070.6714.118.camel@californication> (sfid-20080907_025746_918322_1CBD8424)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > CONFIG_ATH9K_RFKILL needs to be set
> > > to enable this support.
> > 
> > why do we have to introduce yet another config option for this? What is
> > the advantage of disabling RFKILL support? I really don't see it and all
> > these extra config options are rather confusing than useful.
> 
> "if EMBEDDED", I think you may want to build a router without rfkill
> stuff.

so what overhead is it to have RFKILL just enabled all the time. It is a
small subsystem and the extra code inside the drivers is also not that
much. So what are we really trying to save here?

I can see your router point, but does it really matter? I don't think so
and some routers allow to switch WiFi off and then they want the RFKILL
switch again. Also what about the LEDS subsystem. The same would apply
and we are not bothering in just enabling it.

Regards

Marcel


