Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39718 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab0DMLAE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 07:00:04 -0400
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ylalehto Janne \(Nokia-D\/Tampere\)" <janne.ylalehto@nokia.com>
Subject: Re: [RFC PATCH] nl80211: Add support for dynamic ps timeout configuration
References: <1271059902-27788-1-git-send-email-juuso.oikarinen@nokia.com>
	<1271061120.3877.6.camel@jlt3.sipsolutions.net>
	<1271062589.10120.1169.camel@wimaxnb.nmp.nokia.com>
	<1271063175.3877.13.camel@jlt3.sipsolutions.net>
	<1271065535.10120.1191.camel@wimaxnb.nmp.nokia.com>
	<871vekpexo.fsf@purkki.valot.fi>
	<1271143746.10120.1232.camel@wimaxnb.nmp.nokia.com>
	<87wrwboirr.fsf@purkki.valot.fi>
	<1271148573.10120.1257.camel@wimaxnb.nmp.nokia.com>
	<87sk6zoh4x.fsf@purkki.valot.fi>
	<1271149802.10120.1262.camel@wimaxnb.nmp.nokia.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 13 Apr 2010 14:00:01 +0300
In-Reply-To: <1271149802.10120.1262.camel@wimaxnb.nmp.nokia.com> (Juuso Oikarinen's message of "Tue\, 13 Apr 2010 12\:10\:02 +0300")
Message-ID: <87ochnobwu.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

>> AFAIK the pm_qos values are not set in stone in any. Applications just
>> request something and kernel can do whatever it wants, even ignore it.
>> So I don't see any harm if we change how mac80211 uses pm_qos values.
>> And most probably this will change many times in the future.
>
> Ok, you convinced me. I will send a RFC patch with the above, and will
> sub-sequentially be flamed to death ;)

Nah, you are so used to flaming already that you don't feel a thing :)

> Be sure to look into that bug in wl1251 at some point, so I don't break
> it with this, if by chance I get this to go through ;)

I will.

-- 
Kalle Valo
