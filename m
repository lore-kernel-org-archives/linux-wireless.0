Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f206.google.com ([209.85.220.206]:54141 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZFMUvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 16:51:42 -0400
Received: by fxm2 with SMTP id 2so109717fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2009 13:51:43 -0700 (PDT)
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pierre Ossman <pierre@ossman.eu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<1244685780-28930-8-git-send-email-me@bobcopeland.com>
	<20090613132144.6c7783bc@mjolnir.ossman.eu>
	<87bposnmxi.fsf@litku.valot.fi> <1244922097.1852.4.camel@violet>
	<873aa3opsr.fsf@litku.valot.fi> <1244924647.1852.10.camel@violet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 13 Jun 2009 23:44:57 +0300
In-Reply-To: <1244924647.1852.10.camel@violet> (Marcel Holtmann's message of "Sat\, 13 Jun 2009 22\:24\:07 +0200")
Message-ID: <87y6rvn9rq.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann <marcel@holtmann.org> writes:

>> So rfkill is on the opposite side of wl12xx compared to the actual hw
>> power line.
>
> we do have the RFKILL (aka soft killswitch) that is now integrated with
> mac80211 and we do have separate RFKILL hardware killswitches.
>
> For example the Bluetooth pieces inside a laptop now have a Bluetooth
> hardware killswitch (behind a platform device) and the soft killswitch
> from the Bluetooth subsystem. They are two independent pieces.

Oh, I didn't know that. I need to some studying now. Thanks.

> RFKILL is a confusing beast ;)

That's what everyone seem to say :)

-- 
Kalle Valo
