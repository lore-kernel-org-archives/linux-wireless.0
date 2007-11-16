Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:48636 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552AbXKPOQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 09:16:07 -0500
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Li YanBo <dreamfly281@gmail.com>, Ben Gamari <ben@mw0.ath.cx>,
	linux-wireless@vger.kernel.org,
	Jose Ignacio Naranjo Hernandez
	<joseignacio.naranjo@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: Suspend/Resume support
References: <1195087905.3814.11.camel@mercury>
	<1197ff4c0711141937gc7bb1f8w499cd9d8634fa232@mail.gmail.com>
	<1195171869.8147.79.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Fri, 16 Nov 2007 15:24:21 +0200
In-Reply-To: <1195171869.8147.79.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 16 Nov 2007 01\:11\:09 +0100")
Message-ID: <87ir42z5kq.fsf@nokia.com> (sfid-20071116_141612_019448_9A8B62C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> If it is, we need to determine whether we were suspended long enough
> for it to kick us off. It might be possible to do this by sending a
> null function frame to the AP and see if it replies with a deauth
> notification, I think it should if we're not associated [3].

I think that at least most (if not all) of the APs do send a deauth
frame in that case. I have seen this happening when debugging some
bugs. But I don't know if the standard specifies that.

-- 
Kalle Valo
