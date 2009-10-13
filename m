Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35991 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZJMSRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 14:17:36 -0400
To: linux-omap@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rx51: add wl1251 wlan driver support
References: <20091013165812.1623.66247.stgit@tikku>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 13 Oct 2009 21:16:57 +0300
In-Reply-To: <20091013165812.1623.66247.stgit@tikku> (Kalle Valo's message of "Tue\, 13 Oct 2009 19\:58\:13 +0300")
Message-ID: <87ljjfnopy.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> From: Kalle Valo <kalle.valo@nokia.com>
>
> wl1251 is connected to the SPI bus in rx51, add support for this.
>
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>

This is intended for 2.6.33. Also to really work it needs this patch:

wl1251: rename spi device to wl1251
http://www.spinics.net/lists/linux-wireless/msg40740.html

The patch should be in wireless-testing within next few days and
finally it will go to 2.6.33.

(Please note that the two patches have no compile time dependency so
they can go to mainline via separate trees.)

-- 
Kalle Valo
