Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:42096 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab1AaW7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 17:59:15 -0500
Message-ID: <4D473EBC.5040006@davizone.at>
Date: Mon, 31 Jan 2011 23:59:08 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 15/18] wl1251: disable power saving in monitor mode
References: <4D45A79E.7040801@davizone.at> <4D45B7D5.2030408@davizone.at> <87ei7tdqbt.fsf@purkki.adurom.net>
In-Reply-To: <87ei7tdqbt.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 2011-01-31 16:51, schrieb Kalle Valo:
> David Gnedt <david.gnedt@davizone.at> writes:
> 
>> Force power saving off while monitor interface is present.
> 
> Again, why? 
> 
> Maybe to avoid dropping frames when associated? That would make sense.
> But on the other hand someone might want to have power save enabled
> when using monitor mode, for example when debugging power save related
> issues.
> 
> Nevertheless, I think mac80211 is the correct place to do this, not
> the driver.

Yeah, my thought was to avoid dropping frames when associated.
I am going to drop that patch in v2.
