Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25294 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYKML4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 06:56:38 -0500
To: "Mark Ryden" <markryde@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: Master mode in iw
References: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com>
	<87ej1f6ggq.fsf@nokia.com>
	<dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 13 Nov 2008 13:56:24 +0200
In-Reply-To: <dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com> (ext Mark Ryden's message of "Thu\, 13 Nov 2008 13\:49\:01 +0200")
Message-ID: <87wsf74z6f.fsf@nokia.com> (sfid-20081113_125642_017806_CCB57CC2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mark Ryden <markryde@gmail.com> writes:

> Thanks for you quick response. I know that I can set master mode
> with hostapd.
>
> My question is - is there something inherent which prevents
> implementing it with "iw"? When comparing to the old set of tools,
> which includes iwconifg, "iwconfig wlan0 mode Master" works on some
> interfaces.

Just guessing, but most probably because there are no drivers which
use nl80211 and support AP mode without hostapd, so nobody hasn't
bothered to implement it, yet.

-- 
Kalle Valo
