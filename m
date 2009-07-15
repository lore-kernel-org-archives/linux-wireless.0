Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1472 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbZGOMJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 08:09:09 -0400
Date: Wed, 15 Jul 2009 08:08:14 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Ohad Ben-Cohen <ohad@bencohen.org>
Cc: Pierre Ossman <pierre@ossman.eu>, Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless@vger.kernel.org, san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
Message-ID: <20090715120814.GC29682@hash.localnet>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com> <1244685780-28930-8-git-send-email-me@bobcopeland.com> <20090613132144.6c7783bc@mjolnir.ossman.eu> <87bposnmxi.fsf@litku.valot.fi> <20090613220908.271865cd@mjolnir.ossman.eu> <20090613205737.GA30439@hash.localnet> <20090618022524.GC10014@hash.localnet> <bd5b16740907150012j7a687dddr5caee38e26bd9868@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bd5b16740907150012j7a687dddr5caee38e26bd9868@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 10:12:59AM +0300, Ohad Ben-Cohen wrote:
> Hi Bob, Pierre,
> 
> On Thu, Jun 18, 2009 at 5:25 AM, Bob Copeland <me@bobcopeland.com> wrote:
> > +#define SDIO_VENDOR_ID_TI ? ? ? ? ? ? ? ? ? ? ?0x104c
> > +#define SDIO_DEVICE_ID_TI_WL1251 ? ? ? ? ? ? ? 0x9066
> 
> I wonder how those values are derived ?
> 
> Are they officially registered anywhere ?

This is what the card reports, also you can find it in the TI
vendor drivers.  I don't know who the registrar is, but as I
understand, the vendor ID is the same as the PCMCIA vendor ID,
so it's whoever assigns those.  I'm sure 0x9066 is defined by
TI.

-- 
Bob Copeland %% www.bobcopeland.com

