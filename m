Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:33670 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbZDNWFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 18:05:44 -0400
From: Christian Lamparter <chunkeey@web.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [RFC] ar9170: 802.11n RX Part
Date: Wed, 15 Apr 2009 00:05:40 +0200
Cc: linux-wireless@vger.kernel.org
References: <200904142159.59511.chunkeey@web.de> <69e28c910904141329o731a7bcfjde0e5587c20e9058@mail.gmail.com>
In-Reply-To: <69e28c910904141329o731a7bcfjde0e5587c20e9058@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Message-Id: <200904150005.41377.chunkeey@web.de> (sfid-20090415_000547_908601_799F3ADA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 April 2009 22:29:34 G=E1bor Stefanik wrote:
> On Tue, Apr 14, 2009 at 9:59 PM, Christian Lamparter <chunkeey@web.de=
> wrote:
> > With this patch you can finally tune your ar9170 radio to the next =
network
> > and listen to the sound of HT.
> >
> > Of course, you won't be able to sing along with all other 11n devic=
es.
> > We still need a rate algo, BA support (weird stuff!) for HT before
> > we can think about coding it.
> >
> > Regards,
> >        Chr
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wir=
eless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
> A rate algo is needed because wext doesn't support HT rates, and
> nl80211 doesn't yet have a rate selection feature, preventing manual
> setting of HT rates, right?

Hmm, what are you trying to say/ask?

The rate algo is not the "big problem" here... as nbd will do the most =
work.
(in fact its very easy to "emulate" it for now)

BA on the other hand is next to impossible ;-)
And even with code from ath9k, it's still ALOT TODO.

Regards,
	Chr
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
