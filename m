Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:57497 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab1AKWKS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 17:10:18 -0500
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Jason Andryuk <jandryuk@gmail.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Johannes Stezenbach <js@sig21.net>
Subject: Re: 5GHz 802.11n USB Adapter
References: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com>
	<201101101703.45802.helmut.schaa@googlemail.com>
	<87ipxvfqg1.fsf@purkki.adurom.net>
	<201101111557.46845.helmut.schaa@googlemail.com>
	<87ei8jfnq2.fsf@purkki.adurom.net>
	<AANLkTi=n49bXON7i9ec_UGLwMpr2+963CGOudkMphnMt@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 12 Jan 2011 00:10:16 +0200
In-Reply-To: <AANLkTi=n49bXON7i9ec_UGLwMpr2+963CGOudkMphnMt@mail.gmail.com> (Ivo Van Doorn's message of "Tue\, 11 Jan 2011 17\:39\:48 +0100")
Message-ID: <87aaj7f5x3.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo Van Doorn <ivdoorn@gmail.com> writes:

>> That would be the best option, but in the mean time we should disable
>> AP mode.
>
> Ok, but please don't restrict only to rt2800usb then. Basically
> _all_ rt2x00 USB drivers are not functioning. Also I assume it means
> that also Mesh mode, Secondary, and Ad-hoc should also be disabled?

AFAIK Mesh and Ad-Hoc don't use power save mode so not not being able
to buffer bc/mc shouldn't be a problem.

-- 
Kalle Valo
