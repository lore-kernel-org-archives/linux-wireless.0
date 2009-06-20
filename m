Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:18307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZFTE3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 00:29:41 -0400
Received: by fg-out-1718.google.com with SMTP id 16so698838fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 21:29:43 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: Pierre Ossman <pierre@ossman.eu>, linux-wireless@vger.kernel.org,
	san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<1244685780-28930-8-git-send-email-me@bobcopeland.com>
	<20090613132144.6c7783bc@mjolnir.ossman.eu>
	<87bposnmxi.fsf@litku.valot.fi>
	<20090613220908.271865cd@mjolnir.ossman.eu>
	<20090613205737.GA30439@hash.localnet>
	<20090618022524.GC10014@hash.localnet>
	<20090619212419.2f3626d7@mjolnir.ossman.eu>
	<b6c5339f0906191331x6c360d63wec431fc9d35b38c0@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 20 Jun 2009 07:29:40 +0300
In-Reply-To: <b6c5339f0906191331x6c360d63wec431fc9d35b38c0@mail.gmail.com> (Bob Copeland's message of "Fri\, 19 Jun 2009 16\:31\:41 -0400")
Message-ID: <871vpfplxn.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

>> Do you want me to merge it?
>
> It can go via the wireless tree if that's ok with you, since the
> SPI driver already lives there and this all needs to be rebased
> on Kalle Valo's latest changes anyway.

I agree, better to merge all wl12xx patches through John. Otherwise we
start to get conflicts, and that's pain.

-- 
Kalle Valo
