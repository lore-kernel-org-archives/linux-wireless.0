Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:42736 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbcFEKzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 06:55:18 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/RFT 5/5] ath9k: Count RX airtime in airtime deficit
References: <20160603165144.17356-1-toke@toke.dk>
	<20160603165144.17356-6-toke@toke.dk>
	<CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com>
Date: Sun, 05 Jun 2016 12:55:15 +0200
In-Reply-To: <CAJ-VmonzVQ5Yx6mvnvcT4PKTT7CXRR_Vf=K75da04i8GqrhjfQ@mail.gmail.com>
	(Adrian Chadd's message of "Sat, 4 Jun 2016 10:06:08 -0700")
Message-ID: <8737orucq4.fsf@toke.dk> (sfid-20160605_125524_291829_0C0879E7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> writes:

> I've been working on something similar in freebsd, so cool to see this
> happening here!

Cool. Do you have code available somewhere?

> The only thing missing atm is STBC and LDPC. My RX airtime code looks
> basically like this one too; but I have TODO items for ensuring
> LDPC/STBC calculations are sane.

So basically this means taking into account whether there was MIMO in
use (which may lower the transmit time)? My understanding is that (at
least in Linux) this is encoded in the rate tables (i.e. a MIMO rate is
a separate entry). Am I wrong in thinking so? Or is this something else
entirely?

-Toke
